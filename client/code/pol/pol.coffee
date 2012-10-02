Workspace = Backbone.Router.extend(
  routes:
    "lobby": "lobby",
    "game": "game"

  lobby: ->
    $('#content').children().remove()
    $('#content').append ss.tmpl['lobby'].render()

  game: ->
    ss.rpc 'pol.startGame', (response) ->
      $('#content').children().remove()
      $('#content').append ss.tmpl['game'].render()
      console.log(response)
)

ss.rpc 'pol.getCurrentUser', (response) ->
  if response
    window.router = new Workspace
    Backbone.history.start()
    $('#toolbar').append ss.tmpl['toolbar'].render(user: response)
  else
    $('#content').append ss.tmpl['login'].render()

