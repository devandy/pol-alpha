Core = require("../../client/code/pol/shared/core")
Commands = require("../../client/code/pol/shared/commands")
Storage = require("../storage")
_ = require("underscore")
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
      _.each game.cards, (card) ->
        card.on 'change', (attributes, remote) ->
          ss.publish.all('game.update', {id: card.id, attributes: attributes})
      _.each game.players, (player) ->
        player.on 'change', (attributes, remote) ->
          ss.publish.all('game.update', {id: player.id, attributes: attributes})
      @commandHandler = new Commands.CommandHandler(game)
      res(game.for(game.players[0].id))

  execute: (command) =>
    @commandHandler.execute(command)

