class BaseView
  appendTo: (widget) =>
    widget.append @widget
    @

  writeTo: (widget) =>
    widget.html @widget
    @

  view: (card) =>
    $("[cid='#{card.id}']").data('view')

  template: (name, options) =>
    ss.tmpl[name].render(options)

class ToolbarView extends BaseView
  constructor: (@model) ->
    @widget = $(@template('toolbar', @model))

class GameView extends BaseView
  constructor: () ->
    @widget = $(@template('game'))

class CardView extends BaseView
  constructor: (@controller, @model) ->
    @CARD_WIDTH = 53
    @CARD_HEIGHT = 72
    @widget = $(@template('card', @model.attributes))
      .bind('mouseenter', @onMouseEnter)
      .bind('click', @onClick)
      .data('view', @)
      .draggable(helper: 'clone', opacity: 0.8, scroll: false, containment: '.game')

  move: (x, y, animate)->
    if animate
      @widget.transition(left: x, top: y)
    else
      @widget.css('left', x).css('top', y)

  rotate: (enabled) ->
    if enabled
      val = (@CARD_HEIGHT-@CARD_WIDTH) / 2
      @widget.transition(rotate: "90deg", x: "-#{val}px", y: "-#{val}px")
    else
      @widget.transition(rotate: "0deg", x: '0px', y: '0px')

  flip: (enabled) ->
    if enabled
      @widget.transition(rotateY: "180deg")
    else
      @widget.transition(rotateY: "0deg")

  #private

  onClick: (event, ui) =>
    @widget.toggleClass('selected')

  onMouseEnter: (event, ui) =>
    $('.card-magnification').find('img').attr('src', @model.get('imageUrl'))

class CardContainerView extends BaseView
  constructor: (@controller, @code, @cards, selector) ->
    @widget = $(selector)
    _.forEach @cards, (card) =>
      card.on 'change', (attributes, remote) =>
        if @include(card)
          console.log "#{@widget.attr('class')}, updating card #{card.get('name')} from remote: #{remote}"
          @moveCard(card, remote)
          @view(card).rotate(card.get('rotated'))
          @view(card).flip(card.get('flipped'))

  containedCards: =>
    _.filter(@cards, (card) => card.get('container') == @code)

  includeView: (cardView) =>
    _.any(@containedCards(), (card) => card.id == cardView.model.id)

  # private

  include: (card) =>
    _.include(@containedCards(), card)

class BattlefieldView extends CardContainerView
  constructor: (controller, cards) ->
    super(controller, 'battlefield', cards, '.battlefield')
    @widget
      .droppable()
      .bind('drop', @onDrop)
    _.forEach(@containedCards(), (card) => @moveCard(card))

  # private

  moveCard: (card, remote) =>
    @view(card).move(card.get('x'), card.get('y'), remote)

  onDrop: (event, ui) =>
    card = ui.draggable
    x = ui.position.left
    y = ui.position.top
    console.log "Battlefield, executing MoveCard #{card.attr('title')}"
    @controller.execute
      name: 'MoveCard'
      id: card.attr('cid')
      x: x
      y: y
      z: 0
      container: 'battlefield'

class HandView extends CardContainerView
  constructor: (controller, cards) ->
    super(controller, 'hand', cards, '.hand')
    _.forEach(_.range(8), (index) =>
      @widget.append(
        $("<div class='card-slot bordered' index='#{index}'></div>")
          .droppable()
          .bind('drop', @onDrop)
      )
    )
    _.forEach(@containedCards(), (card) => @moveCard(card))

  #private

  moveCard: (card) =>
    slot = $(".card-slot[index=#{card.get('z')}]")
    @view(card).move(slot.offset().left, slot.offset().top, true)

  onDrop: (event, ui) =>
    card = ui.draggable
    slot = $(event.target)
    console.log "Hand, executing command MoveCard #{card.attr('title')}"
    @controller.execute
      name: 'MoveCard'
      id: card.attr('cid')
      x: 0
      y: 0
      z: slot.attr('index')
      container: 'hand'

class PlayerStatusView extends BaseView
  constructor: (@controller, @model) ->
    @widget = $('.player').attr('cid', @model.id)
    @widget.find('.status .avatar').attr('title', model.get('name'))
    @widget.find('.status .avatar img').attr('src', model.get('avatar'))
    @widget.find('.status .life').bind('click', @onClick)
    @model.on 'change', (attributes, remote) =>
      @render()
    @render()

  # private

  onClick: =>
    @controller.execute
      name: 'IncrementLife'
      id: @model.id

  render: =>
    @widget.find('.status .life').text(@model.get('life'))
    @widget.find('.status .hand-count').text('5')

exports.ToolbarView = ToolbarView
exports.GameView = GameView
exports.CardView = CardView
exports.BattlefieldView = BattlefieldView
exports.HandView = HandView
exports.PlayerStatusView = PlayerStatusView