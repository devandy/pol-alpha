Browser = require "zombie"

class LoginPage
  constructor: ->
    @browser = new Browser()

  visit: (done) =>
    @browser.visit "http://localhost:3000/", done

  wait: (milliseconds, done) =>
    @browser.wait milliseconds, done

  title: ->
    @browser.text('h1')

@page = new LoginPage()
@page.visit =>
  @page.browser.wait(5000, =>
    #console.log @page.browser.query('h1')
    #@page.title().should.equal 'Welcome to PoL!'
    console.log @page.browser.html()
    console.log "h1 " + @page.browser.text('h1')

describe 'Login page', ->

  before ->
    @page = new LoginPage()

  it 'should show welcome message', (done) ->
    @page.visit =>
      @page.browser.wait(5000, =>
        #console.log @page.browser.query('h1')
        #@page.title().should.equal 'Welcome to PoL!'
        console.log @page.browser.html()
        console.log "h1 " + @page.browser.text('h1')
        done()
      )



