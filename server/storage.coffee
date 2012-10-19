_ = require("underscore")._
fs = require("fs")
redis = require("redis")

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

exports.UserArchive = class UserArchive
  constructor: (config) ->
    @client = redis.createClient(config.db)
    @client.auth config.db.pass, (err) ->
      throw err if err

  set: (user) =>
    @client.set "users:#{user.id}", JSON.stringify(user)
    @client.hset "users:lookup:providerId", user.providerId, user.id

  get: (id, done) =>
    @client.get "users:#{id}", (err, user) =>
      done err, JSON.parse(user)

  getByProviderId: (providerId, done) =>
    @client.hget "users:lookup:providerId", providerId, (err, id) =>
      @get id, done

  newId: (done) =>
    @client.incr "users", (err, id) =>
      done err, id

