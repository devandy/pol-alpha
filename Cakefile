Resources = require('./code/resources')
fs = require('fs')

option '-s', '--set [CODE]', 'set to generate'

task 'generate:cards', 'generate card resources', (options) ->
  code = options.set or 'm13'
  new Resources.Cards(code).get (items) ->
    fs.writeFile "./resources/#{code}.json", JSON.stringify(items)

