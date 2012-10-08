http = require("http")
ss = require("socketstream")
everyauth = require("everyauth")
Storage = require("./server/storage")

ss.client.define "pol",
  view: "pol.html"
  css: ["game.styl", "libs"]
  code: ["libs", "pol", "system"]
  tmpl: "*"

ss.http.route "/", (req, res) ->
  res.serveClient "pol"

users = new Storage.UserArchive
ss.api.add("users", users)

everyauth.facebook
  .scope("email")
  .appId("262276250559418")
  .appSecret("291a6d02a5026ce17d00c7f35716a879")
  .findOrCreateUser((session, accessToken, accessTokExtra, profile) ->
    promise = @Promise()
    users.getByProviderId profile.id, (err, user) =>
      now = new Date()
      if err
        promise.fail "Error finding user from provider id. #{err}"
      else
        if not user
          users.newId (err, id) =>
            if err
              promise.fail "Cannot generate new id for user. #{err}"
            else
              user =
                id: id
                provider: 'facebook'
                providerId: profile.id
                providerName: profile.name
                email: profile.email
                created: now
                lastConnected: now
              users.set(user)
              session.setUserId user.id
              promise.fulfill(user: user)
        else
          user.lastConnected = now
          users.set(user)
          session.setUserId user.id
          promise.fulfill(user: user)
    promise
  ).redirectPath "/"
everyauth.everymodule.handleLogout (req, res) ->
  req.session.setUserId null
  req.logout() # The logout method is added for you by everyauth, too
  @redirect res, @logoutRedirectPath()

ss.http.middleware.prepend ss.http.connect.bodyParser()
ss.http.middleware.append everyauth.middleware()

# Code Formatters
ss.client.formatters.add require("ss-coffee")
ss.client.formatters.add require("ss-stylus")

# Request Responders
ss.responders.add require('ss-heartbeat-responder')

# Use server-side compiled Hogan (Mustache) templates. Others engines available
ss.client.templateEngine.use require("ss-hogan")

# Minimize and pack assets if you type: SS_ENV=production node app.js
ss.client.packAssets()  if ss.env is "production"

# Start web server
server = http.Server(ss.http.middleware)
server.listen 3000

# Start SocketStream
ss.start server

ss.api.heartbeat.on 'connect', (session) ->
  console.log session.userId + " has connected"
ss.api.heartbeat.on 'disconnect', (session) ->
  console.log session.userId + " has disconnected"

#everyauth.twitter
#    .consumerKey('CMkKT5wVGNukREhvC68M7g')
#    .consumerSecret('kqSXhbPzPM3CY5NT7Cbuk1ezsJfrWGNBd37Sdi7unQw')
