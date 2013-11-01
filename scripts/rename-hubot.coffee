# Description:
#   Tell people hubot's new name if they use the old one
#
# Commands:
#   None
#
module.exports = (robot) ->
  robot.hear /^hubot:? (.+)/i, (msg) ->
    response = "Bleep, bloop .. blee .. oh, were you talking to me, use #{robot.name}"
    response += " or #{robot.alias}" if robot.alias
    msg.reply response
    return