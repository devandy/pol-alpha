everyauth = require("everyauth")

exports.ExternalAuth = class ExternalAuth
  constructor: (@users) ->
    self = @
    everyauth.facebook
      .appId("262276250559418")
      .appSecret("291a6d02a5026ce17d00c7f35716a879")
      .findOrCreateUser((session, accessToken, accessTokExtra, profile) ->
        self.checkin(@, session, profile, "facebook")
      ).redirectPath "/"
    everyauth.twitter
      .consumerKey('CMkKT5wVGNukREhvC68M7g')
      .consumerSecret('kqSXhbPzPM3CY5NT7Cbuk1ezsJfrWGNBd37Sdi7unQw')
      .findOrCreateUser((session, accessToken, accessTokenSecret, profile) ->
        self.checkin(@, session, profile, "twitter")
      ).redirectPath "/"
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