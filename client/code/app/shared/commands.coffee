_ = require('underscore')

class MoveCardCommand
  constructor: (@game, @parameters) ->

  execute: ->
    card = @game.findCard(@parameters.id)
    if card.get('container') != @parameters.container
      @parameters.rotated = false
    else
      @parameters.rotated = card.get('rotated')
    card.set
      x: @parameters.x
      y: @parameters.y
      z: @parameters.z
      container: @parameters.container
      rotated: @parameters.rotated

module.exports.MoveCardCommand = MoveCardCommand

class RotateCardCommand
  constructor: (@game, @parameters) ->

  execute: ->
    card = @game.findCard(@parameters.id)
    card.set(rotated: not card.get('rotated'))

module.exports.RotateCardCommand = RotateCardCommand

class FlipCardCommand
  constructor: (@game, @parameters) ->

  execute: ->
    card = @game.findCard(@parameters.id)
    card.set(flipped: not card.get('flipped'))

module.exports.FlipCardCommand = FlipCardCommand

class IncrementLifeCommand
  constructor: (@game, @parameters) ->

  execute: ->
    player = @game.findPlayer(@parameters.id)
    player.set(life: player.get('life') + 1)

module.exports.IncrementLifeCommand = IncrementLifeCommand

class CommandHandler
  constructor: (@receiver) ->

  execute: (parameters) =>
    @createCommand(parameters).execute()

  # private

  createCommand: (parameters) ->
    command = _.find(exports, (command) -> command.name == parameters.name + 'Command')
    new command(@receiver, parameters)

module.exports.CommandHandler = CommandHandler
