Pluggable = require './lib/pluggable'
plugin = new Pluggable()

plugin.use('article.create', (article, next) ->
  article.hook = 'article.create'
  next()
).use('article.create', (article, next) ->
  article.author = 'pluggable'
  next()
)

article =
  title: 'title'
  author: 'author'
  content: 'content'

plugin.run 'article.create', article, ->
  console.log article

plugin.bind 'article.update', (article) ->
  console.log article
, (article) ->
  console.log article.length

plugin.emit 'article.update', 'just a message.'
