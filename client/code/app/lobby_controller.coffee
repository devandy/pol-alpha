LobbyView = require "./lobby_view"

class LobbyController
  show: ->
    view = new LobbyView().writeTo $('#content')
    ss.rpc 'system.onlineusers', (onlineusers) ->
      view.renderUsersCount onlineusers
    ss.rpc 'system.rooms', (rooms) ->
      view.renderRooms rooms
    ss.event.on 'system.onlineusers.change', (onlineusers) ->
      view.renderUsersCount onlineusers

module.exports = LobbyController