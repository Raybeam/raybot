# Description:
#   Utility commands surrounding Hubot uptime.
#
# Commands:
#   hubot ping - Reply with pong
#   hubot echo <text> - Reply back with <text>
#   hubot time - Reply with current time
#   hubot die - End hubot process

module.exports = (robot) ->
  robot.respond /roll (([0-9]+)?(d([0-9]))? ?([\+\-]+)?)+/i, (msg) ->
    msg.send "PONG"
