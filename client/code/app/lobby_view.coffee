Views = require('./views')

module.exports = class LobbyView extends Views.BaseView
  constructor: () ->
    @widget = $(@template('lobby'))

  render: (model) =>
    @widget.find('span').text(model.usersCount) if model.usersCount