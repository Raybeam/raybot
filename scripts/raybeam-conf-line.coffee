# Description:
#   Return the Raybeam conference line.
#
# Commands:
#   raybot conf me - Get the Raybeam conference line
#
module.exports = (robot) ->
  robot.respond /(conference|conf) me/i, (msg) ->
    msg.send process.env.RAYBOT_CONFERENCE_LINE + " (H: 7940858) (P: 7666515)"
