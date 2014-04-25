# Description:
#   Let's give Raybot some personality
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#  Hubot: (Chat)

module.exports = (robot) ->
  
  robot.respond /: (.*)/, (msg) -> 
    msg.http("http://www.pandorabots.com/pandora/talk-xml")
      .query({
          botid: "aca6d6a0de343841",
          input: msg.match[1],
          custid: 1337
        })
      .get() (err, res, body) ->
        if err or res.statusCode isnt 200
          msg.send "I don't feel much like talking right now."
          return
        data = body 
        data = data.substring(data.indexOf("<that>")+6, data.indexOf("</that>"))
        msg.send data
 

