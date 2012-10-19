http = require("http")
ss = require("socketstream")
Storage = require("./server/storage")
Rooms = require("./client/code/pol/shared/rooms")
config = require("./server/config")

users = new Storage.UserArchive(config)
rooms = new Rooms()

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
ss.api.add("rooms", rooms)

# Code Formatters
ss.client.formatters.add require("ss-coffee")
ss.client.formatters.add require("ss-stylus")

# Request Responders
ss.responders.add require('./server/ss-heartbeat-responder'), config.db

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
  ss.api.heartbeat.allConnected (sessions) ->
    ss.api.publish.all 'system.onlineusers.change', sessions.length
ss.api.heartbeat.on 'disconnect', (session) ->
  ss.api.heartbeat.allConnected (sessions) ->
    ss.api.publish.all 'system.onlineusers.change', sessions.length

# Start web server
server = http.Server(ss.http.middleware)
server.listen 3000

# Start SocketStream
ss.start server

#ss.ws.transport.use('socketio', {
#client: {
#transports: ['xhr-polling']
#},
#server: function(io){
#io.set('polling duration', 10)
#}
#});
