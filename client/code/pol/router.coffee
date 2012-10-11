ModelsStore = require "./models_store"
Core = require "./shared/core"
Commands = require "./shared/commands"
Views = require "./views"

class RemoteCommandHandler
  constructor: (@commandHandler) ->

  execute: (parameters) =>
    @commandHandler.execute parameters
    ss.rpc 'pol.execute', parameters

module.exports = Backbone.Router.extend
  routes:
    "": "lobby",
    "game": "game"
    "logout": "logout"

  initialize: (user) ->
    ss.heartbeatStart()
    new Views.ToolbarView(user: user).writeTo $('#toolbar')

  logout: ->
    ss.heartbeatStop()
    window.location = "/logout"

  lobby: ->
    view = new Views.LobbyView().writeTo $('#content')
    ss.rpc 'pol.onlineUsers', (response) ->
      view.render(usersCount: response)

  game: ->
    ss.rpc 'pol.startGame', (response) ->
      new Views.GameView().writeTo $('#content')
      game = Core.Game.parse(response)
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