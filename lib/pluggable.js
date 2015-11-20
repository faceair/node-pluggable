var EventEmitter, Pluggable, _, async,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  slice = [].slice;

async = require('async');

_ = require('lodash');

EventEmitter = require('events').EventEmitter;

module.exports = Pluggable = (function(superClass) {
  extend(Pluggable, superClass);

  function Pluggable() {
    return Pluggable.__super__.constructor.apply(this, arguments);
  }

  Pluggable.prototype.use = function() {
    var fn, fns, i, len, match_param;
    fns = 1 <= arguments.length ? slice.call(arguments, 0) : [];
    if (_.isUndefined(this.container)) {
      this.container = [];
    }
    match_param = _.first(fns);
    if (_.isRegExp(match_param)) {
      match_param = fns.shift();
    } else if (_.isFunction(match_param)) {
      match_param = /.*/;
    } else if (_.isString(match_param)) {
      try {
        match_param = new RegExp(fns.shift(), 'i');
      } catch (_error) {
        throw new Error('Create regexp failed.');
      }
    }
    for (i = 0, len = fns.length; i < len; i++) {
      fn = fns[i];
      if (fn) {
        this.container.push([match_param, fn]);
      }
    }
    return this;
  };

  Pluggable.prototype.run = function() {
    var callback, i, match, match_param, params;
    match_param = arguments[0], params = 3 <= arguments.length ? slice.call(arguments, 1, i = arguments.length - 1) : (i = 1, []), callback = arguments[i++];
    if (_.isUndefined(this.container)) {
      this.container = [];
    }
    if (!_.isFunction(callback)) {
      params = _.union(params, [callback]);
      callback = void 0;
    }
    match = (function(_this) {
      return function(param) {
        return _.filter(_this.container, function(arg) {
          var match_param;
          match_param = arg[0];
          try {
            return param.match(match_param);
          } catch (_error) {
            return false;
          }
        });
      };
    })(this);
    async.eachSeries(match(match_param), (function(_this) {
      return function(arg, callback) {
        var err, fn, match_param;
        match_param = arg[0], fn = arg[1];
        try {
          return fn.apply(_this, _.union(params, [callback]));
        } catch (_error) {
          err = _error;
          return callback(err);
        }
      };
    })(this), function(err) {
      if (callback) {
        return callback(err);
      }
    });
    return this;
  };

  Pluggable.prototype.bind = function() {
    var fn, fns, i, len, match_param;
    match_param = arguments[0], fns = 2 <= arguments.length ? slice.call(arguments, 1) : [];
    for (i = 0, len = fns.length; i < len; i++) {
      fn = fns[i];
      this.on(match_param, fn);
    }
    return this;
  };

  return Pluggable;

})(EventEmitter);
