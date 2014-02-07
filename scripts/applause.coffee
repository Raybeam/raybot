# Description:
#   Congratulate a user on their achievement
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot award <user name>: <award name>
#
# Author:
#   dhollis (with thanks to kmcmanus)

applause = [
  "http://media.giphy.com/media/gpXfKa9xLAR56/giphy.gif",
  "http://media2.giphy.com/media/b9aScKLxdv0Y0/giphy.gif",
  "http://media0.giphy.com/media/11uArCoB4fkRcQ/giphy.gif",
  "http://media.giphy.com/media/QKESIqxh398wo/giphy.gif",
  "http://media.tumblr.com/tumblr_mcbic3K3EF1rrpsd7.gif"
]

module.exports = (robot) ->
  robot.respond /award (.*?): (.*)/i, (msg) ->
    users = robot.brain.usersForFuzzyName(msg.match[1].trim())
    if users.length is 1
      user = users[0]
    else if users.length > 1
      user = { name: 'everyone' }
    else
      user = { name: null }
    
    response = []
    
    response.push "And the award for #{msg.match[2]} goes to..."
    response.push "(drum roll)"
    if user.name is null
      response.push "... I'm sorry. This is odd. There's no name written in this envelope."
    else
      response.push "#{user.name}!"
      response.push msg.random applause
      response.push "This is #{user.name}'s #{msg.random ['first', 'second', 'third']} win."
    
    msg.send response...
