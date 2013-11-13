# Description:
#   Send messages to users the next time they speak
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot ambush <user name>: <message>
#
# Author:
#   jmoses

appendAmbush = (data, toUser, fromUser, message) ->
  data[toUser.name] or= []

  data[toUser.name].push [fromUser.name, message]

checkAmbushes = (data, forUser) ->
  if (ambushes = data[forUser.name])
    messages = ("#{forUser.name}: #{message} [#{from}]" for [from, message] in ambushes)
    delete data[forUser.name]
    messages
  else
    []

module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.ambushes ||= {}

  robot.respond /ambush (.*?): (.*)/i, (msg) ->
    users = robot.brain.usersForFuzzyName(msg.match[1].trim())
    if users.length is 1
      user = users[0]
      appendAmbush(robot.brain.data.ambushes, user, msg.message.user, msg.match[2])
      msg.send "Ambush prepared"
    else if users.length > 1
      msg.send "Too many users like that"
    else
      msg.send "#{msg.match[1]}? Never heard of 'em"

  robot.hear /./i, (msg) ->
    return unless robot.brain.data.ambushes?
    for ambush in (checkAmbushes robot.brain.data.ambushes, msg.message.user)
      msg.send ambush
  
  robot.enter (msg) ->
    return unless robot.brain.data.ambushes?
    for ambush in (checkAmbushes robot.brain.data.ambushes, msg.message.user)
      msg.send ambush
