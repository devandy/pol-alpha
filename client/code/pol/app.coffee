Views = require "./views"
Router = require "./router"

ss.rpc 'pol.getCurrentUser', (response) =>
  if response
    ss.heartbeatStart()
    new Views.ToolbarView(user: response).writeTo $('#toolbar')
    window.router = new Router()
    Backbone.history.start()
  else
    $('#content').html ss.tmpl['login'].render()

