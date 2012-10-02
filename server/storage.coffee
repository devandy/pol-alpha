_ = require("underscore")._
fs = require("fs")

exports.CardsArchive = class CardsArchive
  constructor: (@set = 'm13') ->
    @items = []

  load: (cb) ->
    fs.readFile("resources/#{@set}.json", (err, data) =>
      @items = JSON.parse(data)
      cb(@)
    )

  top: (amount) ->
    _.first(@items, amount)

  readAll: ->
    @items