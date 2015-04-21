async = require 'async'
_ = require 'lodash'
{EventEmitter} = require 'events'

module.exports = class Pluggable
  constructor: ->
    @_stack = []
    @_event = new EventEmitter()

  _match: (param) ->
    _.filter @_stack, ([match_param]) ->
      try
        param.match match_param
      catch
        false

  use: (fns...) ->
    match_param = _.first fns
    if _.isRegExp match_param
      match_param = fns.shift()
    else if _.isFunction match_param
      match_param = /.*/
    else if _.isString match_param
      try
        match_param = new RegExp(fns.shift(), 'i')
      catch
        throw new Error 'Create regexp failed.'

    for fn in fns
      @_stack.push [match_param, fn]
    @

  del: (match_param, fns...) ->
    matched_stack = @_match match_param
    @_stack = _.filter matched_stack, ([matched_param, matched_fns]) ->
      ! _.some fns, (fn) ->
        fn.toString() is matched_fns.toString()
    @

  run: (match_param, params..., callback) ->
    unless _.isFunction callback
      params = _.union params, [ callback ]
      callback = undefined

    async.eachSeries @_match(match_param), ([match_param, fn], callback) =>
      try
        fn.apply @, _.union params, [ callback ]
      catch err
        callback err
    , (err) =>
      callback err if callback
      @

  on: (params...) ->
    @_event.on.apply @, params
    @

  bind: (match_param, fns...) ->
    for fn in fns
      @on match_param, fn
    @

  emit: (params...) ->
    @_event.emit.apply @, params
    @
