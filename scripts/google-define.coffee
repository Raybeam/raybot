# Description:
#   A way to interact with the Google Definition API.
#
# Commands:
#   hubot define <word> - Defines word

module.exports = (robot) ->
  robot.respond /(define)( me)? (.*)/i, (msg) ->
    define(msg, msg.match[3], (definition) ->
      msg.reply definition
    )

define = (msg, query, cb) ->
  msg.http('http://www.google.com/dictionary/json?callback=a&sl=en&tl=en&q=' + query).get() (err, res, body) ->
    data = body.substring(2, body.length - 10)
      .replace(new RegExp("\\\\x3c", "g"), "<")
      .replace(new RegExp("\\\\x3e", "g"), ">")
      .replace(new RegExp("\\\\x27", "g"), "'")
    parsed = JSON.parse(data)
    if typeof parsed.primaries != 'undefined'
      p = parsed.primaries[0]
      if typeof p.entries != 'undefined' and p.entries.length > 1
        e = p.entries[1]
        if typeof e.terms != 'undefined'
          term = e.terms[0]
          cb term.text
          return
    cb "Sorry, I don't know that word."
