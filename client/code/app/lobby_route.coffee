ss = require('socketstream')
LobbyView = require('./lobby_view')

module.exports = ->
  register: (router) ->
    router.route "", "lobby", @run

  run: ->
    view = new LobbyView().writeTo $('#content')
    ss.rpc 'system.onlineusers', (onlineusers) ->
      view.render(usersCount: onlineusers)
    ss.rpc 'system.rooms', (rooms) ->
      view.render(rooms: rooms)
    ss.event.on 'system.onlineusers.change', (data) ->
      view.render(usersCount: data)
