async = require 'async'
_ = require 'lodash'
{EventEmitter} = require 'events'

module.exports = class Pluggable extends EventEmitter
  use: (fns...) ->
    @container = [] if _.isUndefined @container

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
      @container.push [match_param, fn]
    return @

  run: (match_param, params..., callback) ->
    @container = [] if _.isUndefined @container

    unless _.isFunction callback
      params = _.union params, [ callback ]
      callback = undefined

    match = (param) =>
      _.filter @container, ([match_param]) ->
        try
          param.match match_param
        catch
          false

    async.eachSeries match(match_param), ([match_param, fn], callback) =>
      try
        fn.apply @, _.union params, [ callback ]
      catch err
        callback err
    , (err) ->
      callback err if callback

    return @

  bind: (match_param, fns...) ->
    for fn in fns
      @on match_param, fn
    return @
