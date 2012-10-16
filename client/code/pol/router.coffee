Views = require "./views"
LobbyRoute = require "./lobby_route"
LogoutRoute = require "./logout_route"
GameRoute = require "./game_route"

module.exports = Backbone.Router.extend
  initialize: (user) ->
    ss.heartbeatStart()

    new Views.ToolbarView(user: user).writeTo $('#toolbar')

    new LobbyRoute().register(@)
    new LogoutRoute().register(@)
    new GameRoute().register(@)
