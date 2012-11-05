Views = require('./views')

module.exports = class LobbyView extends Views.BaseView
  constructor: () ->
    @widget = $(@template('lobby'))

  renderUsersCount: (usersCount) =>
    @widget.find('span').text(usersCount)

  renderRooms: (rooms) =>
    _.forEach rooms, (room) =>
      @widget.find('tbody').append $(@template('lobbyroom'))
