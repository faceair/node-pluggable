## node-pluggable

Add your Hook more easily.

### Use

Simply install it through npm

`npm install node-pluggable`

### Example

    pluggable = require('node-pluggable')()

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


### License

The MIT License (MIT)

Copyright (c) 2015 faceair

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.