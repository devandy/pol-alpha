Browser = require "zombie"

browser = new Browser()
browser.waitDuration = 15000

cacca = ->
  browser.query('body #login-title')

console.log new Date
browser.visit "http://localhost:3000/", ->
  console.log new Date
  browser.wait 15000, ->
    console.log new Date
    console.log browser.html()
    console.log browser.text('body')
    console.log browser.text('body #login-title')
