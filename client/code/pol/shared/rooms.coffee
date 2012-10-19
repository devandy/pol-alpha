Models = require './models'

module.exports = class Rooms extends Models.ObservableCollection
  constructor: ->
    @push {id: 0, name: 'Newbies!', users: 12}
    @push = {id: 1, name: 'Experts!', users: 4}
