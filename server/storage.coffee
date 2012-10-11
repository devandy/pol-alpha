_ = require("underscore")._
fs = require("fs")
redis = require("redis")
config = require("./config")

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

#redis://nodejitsu:03fe3dce079dfcd12560cdebe05631a0@fish.redistogo.com:9201/
#@client= redis.createClient(9201, "fish.redistogo.com")
#client.auth '03fe3dce079dfcd12560cdebe05631a0', (err) ->
# throw err if err

exports.UserArchive = class UserArchive
  constructor: ->
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