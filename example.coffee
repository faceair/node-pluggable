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

pluggable.on 'article.create', article, ->
  console.log article
