## node-pluggable

Add your Hook more easily.

[![Build Status](https://travis-ci.org/faceair/node-pluggable.svg?branch=master)](https://travis-ci.org/faceair/node-pluggable)

## Demo

* [lyssa](https://github.com/faceair/lyssa)

## Installation

`npm install node-pluggable`

## API

    Pluggable = require 'node-pluggable'
    plugin = new Pluggable()

### use([match_param ,] hook_callback...) => this

    plugin.use('article.create', (article, next) ->
      article.hook = 'article.create'
      next()
    )

+ this method is similar to [connect](https://github.com/senchalabs/connect)
+ `match_param` must be `string` or `regex`
+ `hook_callback` will be called when `param` is matched

#### run(param, hook_callback_params...[, callback]) => this

    article =
      title: 'title'
      author: 'author'
      content: 'content'

    plugin.run 'article.create', article, ->
      console.log article

+ `param` will match with `match_param`, which must be `string`
+ `hook_callback_params` will be send to `hook_callback`

### bind(hook_name, hook_callback...) => this

    plugin.bind 'article.update', (article) ->
      console.log article
    , (article) ->
      console.log article.length

+ `hook_callback` will be called when event be emitted

### on(hook_name, hook_callback) => this

    plugin.on 'article.update', (article) ->
      console.log article

* similar to `bind`

### emit(hook_name, data) => this

  plugin.emit 'article.update', 'just a message.'

+ emit an event

### License

[MIT](License)
