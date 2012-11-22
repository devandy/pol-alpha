Browser = require "zombie"
_ = require "underscore"

browser = new Browser()

describe "the main page", ->
  before (done) ->
    browser.visit "http://localhost:3000/", element: '#login-box', -> done()

  it 'should show login', ->
    browser.text('#login-title').should.equal 'Welcome to PoL!'

  describe "when authenticated", ->
    before (done) ->
      browser.clickLink '#facebook-auth a', (error) ->
        done(error)

    it "should show lobby", ->
      console.log browser.html()

describe 'the login box', ->
  before (done) ->
    browser.visit "http://localhost:3000/", element: '#login-box', -> done()

  it 'should contain facebook link', ->
    urls = _.map browser.queryAll('#login-box a'), (link) -> link.attributes.href.value
    urls.should.include '/auth/facebook'

