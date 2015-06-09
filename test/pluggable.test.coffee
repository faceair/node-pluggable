describe 'plugin', ->
  Pluggable = require '../lib/pluggable'

  describe 'use & run', ->
    it 'register global hook', (done) ->
      plugin = new Pluggable()

      plugin.use (message, next) ->
        message.hook = true
        next()

      message = {}
      plugin.run '', message, (err) ->
        message.should.have.property('hook')
        done err

    it 'param isn\'t string', (done) ->
      plugin = new Pluggable()

      plugin.use (message, next) ->
        message.hook = true
        next()

      message = {}
      plugin.run null, message, (err) ->
        message.should.be.empty
        done err

    it 'match_param is regex', (done) ->
      plugin = new Pluggable()

      plugin.use /test/i, (message, next) ->
        message.hook = true
        next()

      message = {}
      plugin.run 'test', message, (err) ->
        message.should.have.property('hook')
        done err

    it 'match_param is string', (done) ->
      plugin = new Pluggable()

      plugin.use 'hook', (message, next) ->
        message.hook = true
        next()

      message = {}
      plugin.run 'hook', message, (err) ->
        message.should.have.property('hook')
        done err

    it 'match_param create regexp failed', (done) ->
      plugin = new Pluggable()

      try
        plugin.use '.\/\\', (message, next) ->
          message.hook = true
          next()
      catch e
        e.should.exist
        done()

    it 'register multi hook', (done) ->
      plugin = new Pluggable()

      plugin.use 'hook', (message, next) ->
        message.hook_1 = true
        next()
      , (message, next) ->
        message.hook_2 = true
        next()

      message = {}
      plugin.run 'hook', message, (err) ->
        message.should.have.property('hook_1')
        message.should.have.property('hook_2')
        done err

    it 'hook callback error', (done) ->
      plugin = new Pluggable()

      plugin.use 'hook', (message, next) ->
        message.hook_1 = true
        next(new Error 'die')

      message = {}
      plugin.run 'hook', message, (err) ->
        err.should.exist
        message.should.have.property('hook_1')
        done()

    it 'no callback', (done) ->
      plugin = new Pluggable()

      plugin.use 'hook', (message, next) ->
        message.hook_1 = true
        next(new Error 'die')

      message = {}
      plugin.run 'hook', message
      done()

    it 'multi params', (done) ->
      plugin = new Pluggable()

      plugin.use 'hook', (article, author, next) ->
        article.author = author
        next()

      article = {}
      plugin.run 'hook', article, 'hook', (err) ->
        article.should.have.property('author')
        done err

    it 'multi params type error', (done) ->
      plugin = new Pluggable()

      plugin.use 'hook', (message, next) ->
        message.hook_1 = true
        next(new Error 'die')

      message = {}
      plugin.run 'hook', message, 'miao', (err) ->
        err.should.exist
        done()

    it 'multi params type error no callback', (done) ->
      plugin = new Pluggable()

      plugin.use 'hook', (message, next) ->
        message.hook_1 = true
        next(new Error 'die')

      message = {}
      plugin.run 'hook', message, 'miao'
      done()

  describe 'event', ->

    describe 'on & emit', ->

      it 'event on', (done) ->
        plugin = new Pluggable()

        plugin.on 'hook', (message) ->
          message.should.have.property('hook')
          done()

        message =
          hook: 'hook'
        plugin.emit 'hook', message

      it 'bind multi hook', (done) ->
        plugin = new Pluggable()

        plugin.bind 'hook', (message) ->
          message.should.have.property('hook')
        , (message) ->
          message.should.have.property('hook')
        , ->
          done()

        message =
          hook: 'hook'
        plugin.emit 'hook', message
