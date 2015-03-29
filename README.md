## node-pluggable

Add your Hook more easily.

[![Build Status](https://travis-ci.org/faceair/node-pluggable.svg?branch=master)](https://travis-ci.org/faceair/node-pluggable)
[![Coverage Status](https://coveralls.io/repos/faceair/node-pluggable/badge.svg)](https://coveralls.io/r/faceair/node-pluggable)

## Installation

`npm install node-pluggable`

## API

    Pluggable = require 'node-pluggable'
    pluggable = new Pluggable()

### use([match_param ,] hook_callback...) => this

    pluggable.use('article.create', (article, next) ->
      article.hook = 'article.create'
      next()
    )

+ this method is similar as express's middleware
+ `match_param` must be string or regex
+ `hook_callback` will be called when param is matched

#### run(param, hook_callback_params...[, callback]) => this

    article =
      title: 'title'
      author: 'author'
      content: 'content'

    pluggable.run 'article.create', article, ->
      console.log article

+ `param` will match with match_param, must be string
+ `hook_callback_params` will send to hook_callback

### del([match_param ,] hook_callback...) => this

    pluggable.del('article.create', (article, next) ->
      article.hook = 'article.create'
      next()
    )

+ reverse with use

### bind(hook_name, hook_callback...) => this

    pluggable.bind 'article.update', (article) ->
      console.log article
    , (article) ->
      console.log article.length

+ `hook_callback` will be called when event be emitted

### on(hook_name, hook_callback) => this

    pluggable.on 'article.update', (article) ->
      console.log article

* similar as bind

### emit(hook_name, data) => this

    pluggable.emit 'article.update', 'just a message.'
    
+ emit an event

### demo

* [lyssa](https://github.com/faceair/lyssa)


### License

[MIT](License)