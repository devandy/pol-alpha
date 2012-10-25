module.exports = class ModelsStore
  constructor:->
    @data = {}

  add: (model) ->
    @data[model.id] = model

  addRange: (models) ->
    @data[model.id] = model for model in models

  update: (id, attributes) ->
    @find(id).set(attributes, true)

  find: (id) ->
    @data[id]
