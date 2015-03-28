async = require 'async'
_ = require 'underscore'
{EventEmitter} = require 'events'

exports.match = (param) ->
  _.filter @stack, ([match_param]) ->
    param.match match_param

exports.use = (fns...) ->
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
    @stack.push [match_param, fn]
  @

exports.del = (match_param, fns...) ->
  matched_stack = @match match_param
  @stack = _.filter matched_stack, ([matched_param, matched_fns]) ->
    ! _.some fns, (fn) ->
      fn.toString() is matched_fns.toString()
  @

exports.run = (match_param, params..., callback) ->
  async.eachSeries @match(match_param), ([match_param, fn], callback) ->
    fn.apply @, _.union params, [ callback ]
  , (err) ->
    callback err if callback

exports.bind = (match_param, fns...) ->
  for fn in fns
    @on match_param, fn
  @

module.exports = (stack = []) ->
  _.extend new EventEmitter(), _.extend exports,
    stack: stack