Views = require "./views"
Core = require "./core"

Router = Backbone.Router.extend(
  routes:
    "": "lobby",
    "game": "game"

  lobby: ->
    $('#content').html new Views.LobbyView().render().el

  game: ->
    ss.rpc 'pol.startGame', (response) ->
      game = Core.Game.parse(response)
      $('#content').html new Views.GameView(game).render().el
)

ss.rpc 'pol.getCurrentUser', (response) ->
  #console.log response
  if response
    window.router = new Router
    Backbone.history.start()
    $('#toolbar').html new Views.ToolbarView().render(user: response).el
  else
    $('#content').html ss.tmpl['login'].render()

