describe 'pluggable', ->
  Pluggable = require '../lib/pluggable'

  describe 'use & run', ->
    it 'register global hook', (done) ->
      pluggable = new Pluggable()

      pluggable.use (message, next) ->
        message.hook = true
        next()

      message = {}
      pluggable.run '', message, (err) ->
        message.should.have.property('hook')
        done err

    it 'param isn\'t string', (done) ->
      pluggable = new Pluggable()

      pluggable.use (message, next) ->
        message.hook = true
        next()

      message = {}
      pluggable.run null, message, (err) ->
        message.should.be.empty
        done err

    it 'match_param is regex', (done) ->
      pluggable = new Pluggable()

      pluggable.use /test/i, (message, next) ->
        message.hook = true
        next()

      message = {}
      pluggable.run 'test', message, (err) ->
        message.should.have.property('hook')
        done err

    it 'match_param is string', (done) ->
      pluggable = new Pluggable()

      pluggable.use 'hook', (message, next) ->
        message.hook = true
        next()

      message = {}
      pluggable.run 'hook', message, (err) ->
        message.should.have.property('hook')
        done err

    it 'match_param create regexp failed', (done) ->
      pluggable = new Pluggable()

      try
        pluggable.use '.\/\\', (message, next) ->
          message.hook = true
          next()
      catch e
        e.should.exist
        done()

    it 'register multi hook', (done) ->
      pluggable = new Pluggable()

      pluggable.use 'hook', (message, next) ->
        message.hook_1 = true
        next()
      , (message, next) ->
        message.hook_2 = true
        next()

      message = {}
      pluggable.run 'hook', message, (err) ->
        message.should.have.property('hook_1')
        message.should.have.property('hook_2')
        done err

    it 'hook callback error', (done) ->
      pluggable = new Pluggable()

      pluggable.use 'hook', (message, next) ->
        message.hook_1 = true
        next(new Error 'die')

      message = {}
      pluggable.run 'hook', message, (err) ->
        err.should.exist
        message.should.have.property('hook_1')
        done()

    it 'no callback', (done) ->
      pluggable = new Pluggable()

      pluggable.use 'hook', (message, next) ->
        message.hook_1 = true
        next(new Error 'die')

      message = {}
      pluggable.run 'hook', message
      done()

    it 'multi params', (done) ->
      pluggable = new Pluggable()

      pluggable.use 'hook', (article, author, next) ->
        article.author = author
        next()

      article = {}
      pluggable.run 'hook', article, 'hook', (err) ->
        article.should.have.property('author')
        done err

    it 'multi params type error', (done) ->
      pluggable = new Pluggable()

      pluggable.use 'hook', (message, next) ->
        message.hook_1 = true
        next(new Error 'die')

      message = {}
      pluggable.run 'hook', message, 'miao', (err) ->
        err.should.exist
        done()

    it 'multi params type error no callback', (done) ->
      pluggable = new Pluggable()

      pluggable.use 'hook', (message, next) ->
        message.hook_1 = true
        next(new Error 'die')

      message = {}
      pluggable.run 'hook', message, 'miao'
      done()

    it 'delete hook success', (done) ->
      pluggable = new Pluggable()

      pluggable.use('hook', (message, next) ->
        message.hook = 'hook'
        next()
      ).del('hook', (message, next) ->
        message.hook = 'hook'
        next()
      )

      message = {}
      pluggable.run 'hook', message, (err) ->
        message.should.be.empty
        done err

    it 'delete hook failed', (done) ->
      pluggable = new Pluggable()

      pluggable.use('hook', (message, next) ->
        message.hook = 'hook'
        next()
      ).del('hook', (message, next) ->
        message.hook = 'hook_not_found'
        next()
      )

      message = {}
      pluggable.run 'hook', message, (err) ->
        message.should.have.property('hook')
        done err

  describe 'event', ->

    describe 'on & emit', ->

      it 'event on', (done) ->
        pluggable = new Pluggable()

        pluggable.on 'hook', (message) ->
          message.should.have.property('hook')
          done()

        message =
          hook: 'hook'
        pluggable.emit 'hook', message

      it 'bind multi hook', (done) ->
        pluggable = new Pluggable()

        pluggable.bind 'hook', (message) ->
          message.should.have.property('hook')
        , (message) ->
          message.should.have.property('hook')
        , ->
          done()

        message =
          hook: 'hook'
        pluggable.emit 'hook', message
