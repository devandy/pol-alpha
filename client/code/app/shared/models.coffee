uuid = require('./utils').uuid
EventEmitter2 = require('eventemitter2').EventEmitter2

class Model extends EventEmitter2
  constructor: (attributes = {}) ->
    @id = uuid()
    @attributes = {id: @id}
    @merge(attributes)

  get: (name) ->
    @attributes[name]

  set: (attributes, remote = false) ->
    @merge attributes
    @emit 'change', attributes, remote

  merge: (attributes) ->
    @attributes[key] = val for key, val of attributes

  toRaw: ->
    {id: @id, attributes: @attributes}

  @parse: (rawModel) ->
    model = new Model(rawModel.attributes)
    model.attributes.id = rawModel.id
    model.id = rawModel.id
    model

module.exports.Model = Model

class ObservableCollection extends EventEmitter2

  push: (item) ->
    Array.prototype.push.call(@, item);
    @emit 'push', item

  remove: (item) ->
    Array.prototype.remove.call(@, item);
    @emit 'remove', item

  toRaw: ->
    _.map(@, (item) -> item.toRaw())

  @parse: (rawItems) ->
    collection = new ObservableCollection
    collection.push(Model.parse(item)) for item in rawItems
    collection

module.exports.ObservableCollection = ObservableCollection