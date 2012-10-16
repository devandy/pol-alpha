ss = require('socketstream')
Views = require('./views')

module.exports = ->
  register: (router) ->
    router.route "", "lobby", @action

  action: ->
    view = new Views.LobbyView().writeTo $('#content')
    ss.rpc 'system.onlineusers', (response) ->
      view.render(usersCount: response)
    ss.event.on 'onlineusers:change', (data) ->
      view.render(usersCount: data)
