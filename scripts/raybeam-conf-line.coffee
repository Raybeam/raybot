# Description:
#   Return the Raybeam conference line.
#
# Commands:
#   raybot conf me - Get the Raybeam conference line
#
module.exports = (robot) ->
  robot.respond /(conference|conf) me/i, (msg) ->
    msg.send "1-866-546-3377 (H: 7940858) (P: 7666515)"
