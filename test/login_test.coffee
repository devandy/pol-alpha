Browser = require "zombie"
browser = new Browser()

isTitlePresent = ->
  browser.query('body #login-title')

describe "visit", ->
  before (done) ->
    @browser = new Browser()
    @browser.visit("http://localhost:3000/", element: '#login-title').then done, done

  it "should load the promises page", (done) ->
    @browser.text('#login-title').should.equal 'Welcome to PoL!'
    done()


