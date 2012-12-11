phantom = require 'phantom'

describe 'Array', ->
  it 'should return -1 when the value is not present', (done) ->
    phantom.create (ph) ->
      ph.createPage (page) ->
        page.open "http://www.google.com", (status) ->
          console.log "opened google? ", status
          page.evaluate (-> document.title), (result) ->
          console.log 'Page title is ' + result
          ph.exit()
          done()
