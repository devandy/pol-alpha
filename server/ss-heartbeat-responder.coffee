fs = require("fs")
path = require("path")
EventEmitter = require("events").EventEmitter
redis = require("redis")
async = require("async")

module.exports = (responderId, config, ss) ->
  name = config and config.name or "heartbeat"
  logging = config and config.logging or 0
  purgeDelay = config and config.purgeDelay or 25
  expireDelay = config and config.expireDelay or 40
  beatDelay = config and config.beatDelay or 30
  port = config and config.port or 6479
  host = config and config.host or "127.0.0.1"
  pass = config and config.pass or ""
  options = config and config.options or {}
  db = redis.createClient(port, host, options)
  db.auth pass, (err) ->
    throw err if err
  ss.client.send "mod", "heartbeat-responder", loadFile("responder.js")
  ss.client.send "code", "init", "require('heartbeat-responder')(" + responderId + ", {beatDelay:" + beatDelay + "}, require('socketstream').send(" + responderId + "));"
  ss[name] = new EventEmitter()
  triggerEvent = (ev, sessionId, socketId) ->
    ss.session.find sessionId, socketId, (session) ->
      ss[name].emit ev, session

  ss[name].isConnected = (sid, cb) ->
    db.hexists name, sid, cb

  ss[name].allConnected = (callback) ->
    db.hkeys name, (err, res) ->
      async.map res, ((key, cb) ->
        ss.session.find key, null, (sess) ->
          cb null, sess

      ), (err, ret) ->
        callback ret



  ss[name].purge = ->
    db.hgetall name, (err, res) ->
      now = Date.now()
      for sessionId of res
        if res[sessionId] < Date.now()
          ss.log "↪".cyan, name.grey, "disconnect:" + sessionId  if logging >= 1
          triggerEvent "disconnect", sessionId
          db.hdel name, sessionId


  setInterval ss[name].purge, purgeDelay * 1000
  name: name
  interfaces: (middleware) ->
    websocket: (msg, meta, send) ->
      if msg is "0"
        ss.log "↪".cyan, name.grey, "beat:", meta.sessionId  if logging is 2
        db.hset name, meta.sessionId, Date.now() + (expireDelay * 1000)
      else if msg is "1"
        db.hexists name, meta.sessionId, (err, res) ->
          ss.log "↪".cyan, name.grey, ((if (res) then "reconnect:" else "connect:")) + meta.sessionId  if logging >= 1
          triggerEvent ((if (res) then "reconnect" else "connect")), meta.sessionId, meta.socketId
          db.hset name, meta.sessionId, Date.now() + (expireDelay * 1000)

      else if msg is "2"
        ss.log "↪".cyan, name.grey, "disconnect:" + meta.sessionId  if logging >= 1
        triggerEvent "disconnect", meta.sessionId
        db.hdel name, meta.sessionId

loadFile = (name) ->
  fileName = path.join(__dirname, name)
  fs.readFileSync fileName, "utf8"