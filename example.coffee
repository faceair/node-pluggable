pluggable = require './index'

pluggable.register 'article.create', (callback) ->
  callback()

pluggable.register 'article.update', (callback) ->
  console.log 'article.update'
  callback()

article =
  title: 'title'
  author: 'author'
  content: 'content'

pluggable.run 'article.create', ->
  console.log article
