ToolbarView = Backbone.View.extend
  className: "container"

  render: (options) ->
    @$el.html ss.tmpl['toolbar'].render(options)
    @

LobbyView = Backbone.View.extend
  className: "container"

  render: ->
    @$el.html ss.tmpl['lobby'].render()
    @

BattlefieldView = Backbone.View.extend
  el: $('.battlefield').get()

  initialize: ->
    @cards = []

  addCard: (card) ->
    @cards.push card
    @$el.append card.el

  render: ->
    _.each(@cards, (card) -> card.render())

CardView = Backbone.View.extend
  className: "card soft-bordered"

  events:
    "dblclick": "onDblclick",
    "mouseenter": "onMouseenter",
    "click": "onClick",

  render: ->
    @$el
      .html(ss.tmpl['toolbar'].render(@model.attributes))
      .data('view', @)
      .draggable(helper: 'clone', opacity: 0.8, scroll: false, containment: '.game')
    @

  onClick: (event, ui) ->
    @$el.toggleClass('selected')

  onMouseenter: (event, ui) ->
    $('.card-magnification').find('img').attr('src', @model.get('imageUrl'))

  onDblclick: (event, ui) ->
    #@notifyObservers("DoubleClick")

GameView = Backbone.View.extend
  className: "container"

  initialize: (game) ->
    @$el.html ss.tmpl['game'].render()
    @battlefield = new BattlefieldView()
    _.each game.cards, (card) =>
      @battlefield.addCard new CardView(model: card)

  render: ->
    @battlefield.render()
    @

exports.ToolbarView = ToolbarView
exports.LobbyView = LobbyView
exports.BattlefieldView = BattlefieldView
exports.CardView = CardView
exports.GameView = GameView
