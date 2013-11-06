# Description:
#   Set a users's location
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot setloc <user name>: <location>
#
# Author:
#   bbriski

set_location = (data, toUser, location) ->
  data[toUser.name] = location

module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.locations ||= {}

  robot.respond /setloc (.*?): (.*)/i, (msg) ->
    users = robot.brain.usersForFuzzyName(msg.match[1].trim())
    if users.length is 1
      user = users[0]
      set_location(robot.brain.data.locations, user, msg.match[2])
      msg.send "I love that place!"
    else if users.length > 1
      msg.send "Too many users like that"
    else
      msg.send "#{msg.match[1]}? Never heard of 'em"

  robot.respond /where is (.*)/i, (msg) ->
    robot.brain.data.locations ||= {}
    username = msg.match[1].trim()

    users = robot.brain.usersForFuzzyName(username)
    if users.length is 1
      user = users[0]
      if !robot.brain.data.locations[user.name]
        msg.send "Beats me."
      else
        msg.send robot.brain.data.locations[user.name]
    else if users.length > 1
      msg.send "Too many users like that"
    else
      msg.send "#{username}? Never heard of 'em"
