http = require("http")
ss = require("socketstream")
Storage = require("./server/storage")
config = require("./server/config")

users = new Storage.UserArchive

ss.client.define "pol",
  view: "pol.html"
  css: ["game.styl", "libs"]
  code: ["libs", "pol", "system"]
  tmpl: "*"

ss.http.route "/", (req, res) ->
  res.serveClient "pol"

# Auth setup
Auth = require("./server/auth")
auth = new Auth.ExternalAuth(users)

# Middleware
ss.http.middleware.prepend ss.http.connect.bodyParser()
ss.http.middleware.append auth.middleware()

# Api setup
ss.api.add("users", users)

# Code Formatters
ss.client.formatters.add require("ss-coffee")
ss.client.formatters.add require("ss-stylus")

# Request Responders
ss.responders.add require('./server/ss-heartbeat-responder', config.db)

# Session support
ss.session.store.use('redis', config.db);

# Transport
ss.publish.transport.use('redis', config.db);

# Use server-side compiled Hogan (Mustache) templates. Others engines available
ss.client.templateEngine.use require("ss-hogan")

# Minimize and pack assets if you type: SS_ENV=production node app.js
ss.client.packAssets() if ss.env is "production"

# Setup heartbeats
ss.api.heartbeat.on 'connect', (session) ->
  console.log session.userId + " has connected"
ss.api.heartbeat.on 'disconnect', (session) ->
  console.log session.userId + " has disconnected"

# Start web server
server = http.Server(ss.http.middleware)
server.listen 3000

# Start SocketStream
ss.start server

