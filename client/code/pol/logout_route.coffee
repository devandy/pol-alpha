ss = require('socketstream')

module.exports = ->
  register: (router) ->
    router.route "logout", "logout", ->
      ss.heartbeatStop()
      window.location = "/logout"