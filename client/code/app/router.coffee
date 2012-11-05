Views = require "./views"
LobbyController = require "./lobby_controller"
GameController = require "./game_controller"

Router = Backbone.Router.extend
  initialize: (user) ->
    ss.heartbeatStart()

    new Views.ToolbarView(user: user).writeTo $('#toolbar')

    @route "", "lobby", ->
      new LobbyController().show()

    @route "logout", "logout", ->
      ss.heartbeatStop()
      window.location = "/logout"

    @route "game", "game", ->
      new GameController().show()

module.exports = Router