# Description:
#   Allows you to politely request that hubot open the pod bay doors
#
# Commands:
#   hubot open the pod bay doors - Opens the pod bay doors

module.exports = (robot) ->
  robot.respond /open the pod bay doors/i, (msg) ->
    msg.send("I'm sorry " + msg.message.user.name + ", but I'm afraid I can't do that.")
