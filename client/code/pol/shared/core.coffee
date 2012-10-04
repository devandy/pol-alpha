Models = require('./models')
Commands = require('./commands')
_ = require('underscore')

exports.Game = class Game
  constructor: (archive) ->
    @cards = []
    @players = []

  load: (archive) ->
    @players = _.map(_.range(2), (index) => @makePlayer("player #{index}"))

    cards = archive.top(20)
    @prepare(@players[0], cards.slice(0, 10))
    @prepare(@players[1], cards.slice(10, 20))

  findCard: (id) ->
    @findById(@cards, id)

  findPlayer: (id) ->
    @findById(@players, id)

  for: (player) ->
    players: _.map(@players, (model) -> model.toRaw())
    cards: _.map(@cardsOf(player), (model) -> model.toRaw())

  @parse: (rawGame) ->
    game = new Game
    game.players = _.map(rawGame.players, (item) -> Models.Model.parse(item))
    game.cards = _.map(rawGame.cards, (item) -> Models.Model.parse(item))
    game

  # private

  cardsOf: (player) =>
    _.filter(@cards, (card) => card.get('owner') == player)

  prepare: (player, cards) =>
    index = 0
    for card in cards.slice(0, 5)
      @cards.push(@makeCard(card, 'battlefield', player, index++))
    index = 0
    for card in cards.slice(5, 10)
      @cards.push(@makeCard(card, 'hand', player, index++))

  findById: (items, id) =>
    _.find(items, (item) -> item.id == id)

  makeCard: (card, container, owner, index) ->
    new Models.Model(
      name: card.name
      imageUrl: card.imageUrl
      owner: owner.id
      controller: owner.id
      container: container
      rotated: false
      flipped: false
      x: 0
      y: 0
      z: index
    )

  makePlayer: (name) ->
    new Models.Model(
      name: name
      avatar: 'http://www.gravatar.com/avatar/d878a83b462e89bb0d8ac819a3d71a30.png'
      life: 20
    )