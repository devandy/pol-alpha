Core = require("../../client/code/pol/shared/core")
Commands = require("../../client/code/pol/shared/commands")
Storage = require("../storage")

exports.actions = (req, res, ss) ->

  req.use('session')

  # Uncomment line below to use the middleware defined in server/middleware/example
  #req.use('example.authenticated')

  getCurrentUser: ->
    res(req.session.userId)

  startGame: =>
    new Storage.CardsArchive().load (archive) =>
      game = new Core.Game()
      game.load(archive)
      card.register(@) for card in game.cards
      player.register(@) for player in game.players
      @commandHandler = new Commands.CommandHandler(game)
      res(game.for(game.players[0].id))

  execute: (command) =>
    @commandHandler.execute(command)

  # private

  notify: (model, attributes) ->
    ss.publish.all('game:updated', {id: model.id, attributes: attributes})