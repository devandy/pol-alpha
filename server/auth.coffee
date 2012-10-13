everyauth = require("everyauth")
config = require("./config")

exports.ExternalAuth = class ExternalAuth
  constructor: (@users) ->
    self = @
    everyauth.facebook
      .appId(config.auth.facebook.id)
      .appSecret(config.auth.facebook.secret)
      .redirectPath("/")
      .findOrCreateUser (session, accessToken, accessTokExtra, profile) ->
        self.checkin(@, session, profile, "facebook")
    everyauth.twitter
      .consumerKey(config.auth.twitter.id)
      .consumerSecret(config.auth.twitter.secret)
      .redirectPath("/")
      .findOrCreateUser (session, accessToken, accessTokenSecret, profile) ->
        self.checkin(@, session, profile, "twitter")
    everyauth.everymodule.handleLogout (req, res) ->
      req.session.userId = null
      req.logout() # The logout method is added for you by everyauth, too
      @redirect res, @logoutRedirectPath()

  middleware: ->
    everyauth.middleware()

  # private

  checkin: (context, session, profile, provider) ->
    promise = context.Promise()
    @users.getByProviderId profile.id, (err, user) =>
      if err
        promise.fail "Error finding user from provider id. #{err}"
      else
        if not user
          @createUser(promise, session, profile, provider)
        else
          @touchUser(promise, session, user)
    promise

  createUser: (promise, session, profile, provider) =>
    @users.newId (err, id) =>
      if err
        promise.fail "Cannot generate new id for user. #{err}"
      else
        now = new Date()
        user =
          id: id
          provider: provider
          providerId: profile.id
          providerName: profile.name
          created: now
          lastConnected: now
        @saveUser(promise, session, user)

  touchUser: (promise, session, user) =>
    user.lastConnected = new Date()
    @saveUser(promise, session, user)

  saveUser: (promise, session, user) =>
    @users.set(user)
    session.userId = user.id
    session.save()
    promise.fulfill(user: user)