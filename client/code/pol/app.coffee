Views = require "./views"
Router = require "./router"

startSite: (user)->
  window.router = new Router(user)
  Backbone.history.start()

ss.rpc 'pol.getCurrentUser', (user) =>
  if user
    startSite(user)
  else
    $('#content').html ss.tmpl['login'].render()

