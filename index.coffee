dottie = require 'dottie'
async = require 'async'
_ = require 'underscore'

exports.hooks = {}

exports.get = (hook_name) ->
  return dottie.get(exports.hooks, hook_name) ? []

exports.set = (hook_name, hooks) ->
  dottie.set exports.hooks, hook_name, hooks
  return exports.hooks

exports.register = (hook_name, plugin) ->
  hooks = exports.get hook_name
  hooks.push plugin
  return exports.set hook_name, hooks

exports.remove = (hook_name, plugin_remove) ->
  hooks = exports.get hook_name
  hooks = _.compact _.map hooks, (plugin_exist) ->
    if plugin_exist.toString() is plugin_remove.toString()
      return null
    else
      return plugin_exist
  return exports.set hook_name, hooks

exports.run = (hook_name, params..., callback) ->
  async.eachSeries exports.get(hook_name), (plugin, callback) ->
    plugin.apply this, _.union params, [ callback ]
  , callback
