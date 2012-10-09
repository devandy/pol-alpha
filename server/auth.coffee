everyauth = require("everyauth")

#everyauth.twitter
#    .consumerKey('CMkKT5wVGNukREhvC68M7g')
#    .consumerSecret('kqSXhbPzPM3CY5NT7Cbuk1ezsJfrWGNBd37Sdi7unQw')

exports.ExternalAuth = class ExternalAuth
  constructor: (@users) ->
    self = @
    everyauth.facebook
      .scope("email")
      .appId("262276250559418")
      .appSecret("291a6d02a5026ce17d00c7f35716a879")
      .findOrCreateUser((session, accessToken, accessTokExtra, profile) ->
        promise = @Promise()
        self.users.getByProviderId profile.id, (err, user) =>
          if err
            promise.fail "Error finding user from provider id. #{err}"
          else
            now = new Date()
            if not user
              self.createUser(id, profile, now, session, promise)
            else
              self.touchUser(user, now, session, promise)
        promise
      ).redirectPath "/"
    everyauth.everymodule.handleLogout (req, res) ->
      req.session.userId = null
      req.logout() # The logout method is added for you by everyauth, too
      @redirect res, @logoutRedirectPath()

  middleware: ->
    everyauth.middleware()

  # private

  createUser: (id, profile, now, session, promise) =>
    @users.newId (err, id) =>
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
        @saveUser(user, session, promise)

  touchUser: (user, now, session, promise) =>
    user.lastConnected = now
    @saveUser(user, session, promise)

  saveUser: (user, session, promise) =>
    @users.set(user)
    session.userId = user.id
    session.save()
    promise.fulfill(user: user)