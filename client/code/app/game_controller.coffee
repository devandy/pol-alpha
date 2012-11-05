Views = require "./views"
Game = require "./shared/game"
Commands = require "./shared/commands"
ModelsStore = require "./models_store"

class RemoteCommandHandler
  constructor: (@commandHandler) ->

  execute: (parameters) =>
    @commandHandler.execute parameters
    ss.rpc 'game.execute', parameters

class GameController
  show: ->
    ss.rpc 'game.start', (response) ->
      new Views.GameView().writeTo $('#content')
      game = Game.parse(response)
      commandHandler = new RemoteCommandHandler(new Commands.CommandHandler(game))
      modelsStore = new ModelsStore
      modelsStore.addRange(game.cards)
      modelsStore.addRange(game.players)
      _.forEach(game.cards, (card) ->
        new Views.CardView(commandHandler, card).appendTo($('.game')))
      new Views.PlayerStatusView(commandHandler, game.players[0])
      new Views.BattlefieldView(commandHandler, game.cards)
      new Views.HandView(commandHandler, game.cards)

      ss.event.on 'game.update', (data) ->
        console.log 'game.update'
        modelsStore.update(data.id, data.attributes)

module.exports = GameController