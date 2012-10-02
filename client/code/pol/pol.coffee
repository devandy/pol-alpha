Workspace = Backbone.Router.extend(
  routes:
    "alert": "alert" # #help

  alert: ->
    alert('clicked!')
)
window.router = new Workspace

Backbone.history.start()

$('#content').append ss.tmpl['login'].render()

$('h1').bind('dblclick', -> window.location = "#alert")