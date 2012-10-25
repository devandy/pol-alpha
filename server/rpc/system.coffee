exports.actions = (req, res, ss) ->

  req.use('session')
  # Uncomment line below to use the middleware defined in server/middleware/example
  #req.use('example.authenticated')

  user: ->
    ss.users.get req.session.userId, (err, user) ->
      res(user)

  onlineusers: ->
    ss.heartbeat.allConnected (sessions) ->
      res(sessions.length)

  rooms: ->
    res(ss.rooms)



