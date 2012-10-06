Views = require "./views"
Storage = require "./storage"
Core = require "./shared/core"
Commands = require "./shared/commands"

class CommandHandlerDecorator
  constructor: (@commandHandler) ->

  execute: (parameters) =>
    @commandHandler.execute(parameters)
    ss.rpc 'pol.execute', parameters

Router = Backbone.Router.extend
  routes:
    "": "lobby",
    "game": "game"

  lobby: ->
    new Views.LobbyView().renderTo $('#content')

  game: ->
    ss.rpc 'pol.startGame', (response) ->
      new Views.GameView().renderTo $('#content')
      game = Core.Game.parse(response)
      commandHandler = new CommandHandlerDecorator(new Commands.CommandHandler(game))
      modelsStore = new Storage.ModelsStore
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

ss.rpc 'pol.getCurrentUser', (response) =>
  #console.log response
  if response
    new Views.ToolbarView(user: response).renderTo $('#toolbar')
    window.router = new Router()
    Backbone.history.start()
  else
    $('#content').html ss.tmpl['login'].render()