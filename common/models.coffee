_ = require('underscore')._
uuid = require('./utils').uuid

exports.Model = class Model
  constructor: (attributes = {}) ->
    @attributes = {}
    @observers = []
    @id = uuid()
    @merge(attributes)

  register: (observer) ->
    @observers.push(observer)

  get: (name) ->
    @attributes[name]

  set: (attributes, remote = false) ->
    @merge(attributes)
    @notifyObservers(attributes, remote)

  merge: (attributes) ->
    @attributes[key] = val for key, val of attributes

  notifyObservers: (attributes, remote) ->
    observer.notify(@, attributes, remote) for observer in @observers

  toRaw: ->
    {id: @id, attributes: @attributes}

  @parse: (rawModel) ->
    model = new Model(rawModel.attributes)
    model.id = rawModel.id
    model


exports.ObservableCollection = class ObservableCollection
  constructor: ->
    @observers = []

  register: (observer) ->
    @observers.push(observer)

  push: (item) ->
    Array.prototype.push.call(@, item);
    @notifyObservers("Push", item)

  remove: (item) ->
    Array.prototype.remove.call(@, item);
    @notifyObservers("Remove", item)

  toRaw: ->
    _.map(@, (item) -> item.toRaw())

  @parse: (rawItems) ->
    collection = new ObservableCollection
    collection.push(Model.parse(item)) for item in rawItems
    collection

  # private

  notifyObservers: (action) ->
    observer["notify#{action}"](@, item) for observer in @observers