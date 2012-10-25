Views = require "./views"
Router = require "./router"

ss.rpc 'system.user', (user) =>
  if user
    window.router = new Router(user)
    Backbone.history.start()
  else
    $('#content').html ss.tmpl['login'].render()


