Core = require("../../client/code/pol/core")
Storage = require("../storage")

exports.actions = (req, res, ss) ->

  req.use('session')

  # Uncomment line below to use the middleware defined in server/middleware/example
  #req.use('example.authenticated')

  getCurrentUser: ->
    res(req.session.userId)

  startGame: ->
    new Storage.CardsArchive().load (archive) ->
      game = new Core.Game()
      game.load(archive)
      res(game.for(game.players[0].id))