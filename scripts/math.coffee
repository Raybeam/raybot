# Description:
#   Allows Hubot to do mathematics.
#
# Commands:
#   hubot math me <expression> - Calculate the given expression.
#   hubot convert me <expression> to <units> - Convert expression to given units.
module.exports = (robot) ->
  robot.respond /(calc|calculate|calculator|convert|math|maths)( me)? (.*)/i, (msg) ->
    msg.send "igoogle has been shut down. Thanks Obamacare."

