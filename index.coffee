async = require 'async'
_ = require 'underscore'
{EventEmitter} = require 'events'

pluggable = new EventEmitter()

pluggable.stack = []

pluggable.match = (param) ->
  _.filter pluggable.stack, ([match_param]) ->
    param.match match_param

pluggable.use = (fns...) ->
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
    pluggable.stack.push [match_param, fn]
  pluggable

pluggable.del = (match_param, fns...) ->
  matched_stack = pluggable.match match_param
  pluggable.stack = _.filter matched_stack, ([matched_param, matched_fns]) ->
    ! _.some fns, (fn) ->
      fn.toString() is matched_fns.toString()
  pluggable

pluggable.run = (match_param, params..., callback) ->
  async.eachSeries pluggable.match(match_param), ([match_param, fn], callback) ->
    fn.apply this, _.union params, [ callback ]
  , (err) ->
    callback err if callback

pluggable.bind = (match_param, fns...) ->
  for fn in fns
    pluggable.on match_param, fn
  pluggable

module.exports = pluggable