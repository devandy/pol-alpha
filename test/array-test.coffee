Browser = require "zombie"

describe 'Array', ->
  describe '#indexOf()', ->
    it 'should return -1 when not present', ->
      [1,2,3].indexOf(4).should.equal -1

describe 'visit', ->

  before (done) ->
    @browser = new Browser()
    @browser.visit("http://localhost:3000/")
      .then(done, done)

  it 'should load the login page', ->
    console.log @browser.html()
    console.dir("Errors reported:", @browser.errors) if @browser.error

    @browser.success.should.be.true
    @browser.text('h1').should.equal 'Welcome to PoL!'
