ss = require('socketstream')
Views = require('./views')
ModelsStore = require "./models_store"
Game = require "./shared/game"
Commands = require "./shared/commands"

class RemoteCommandHandler
  constructor: (@commandHandler) ->

  execute: (parameters) =>
    @commandHandler.execute parameters
    ss.rpc 'game.execute', parameters

module.exports = ->
  register: (router) ->
    router.route "game", "game", ->
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