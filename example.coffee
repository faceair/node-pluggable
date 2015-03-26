pluggable = require './index'

pluggable.use('article.create', (article, next) ->
  article.hook = 'article.create'
  next()
).del('article.create', (article, next) ->
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

pluggable.run 'article.create', article, ->
  console.log article

pluggable.bind 'article.update', (article) ->
  console.log article
, (article) ->
  console.log article.length

pluggable.emit 'article.update', 'just a message.'
