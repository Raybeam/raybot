doge_image = ->
  "░░░░░░░░░░░░░░░▄░░░░░░░░░░░░░░▄░░░░░░░░░░\n░░░░░░░░░░░░░░▌▒█░░░░░░░░░░░▄▀▒▌░░░░░░░░░\n░░░░░░░░░░░░░░▌▒▒█░░░░░░░░▄▀▒▒▒▐░░░░░░░░░\n░░░░░░░░░░░░░▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐░░░░░░░░░\n░░░░░░░░░░░▄▄▀▒░▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐░░░░░░░░░\n░░░░░░░░░▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌░░░░░░░░░\n░░░░░░░░▐▒▒▒▄▄▒▒▒▒░░░▒▒▒▒▒▒▒▀▄▒▒▌░░░░░░░░\n░░░░░░░░▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐░░░░░░░░\n░░░░░░░▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄▌░░░░░░░\n░░░░░░░▌░▒▄██▄▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▌░░░░░░░\n░░░░░░▀▒▀▐▄█▄█▌▄░▀▒▒░░░░░░░░░░▒▒▒▐░░░░░░░\n░░░░░░▐▒▒▐▀▐▀▒░▄▄▒▄▒▒▒▒▒▒░▒░▒░▒▒▒▒▌░░░░░░\n░░░░░░▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒▒▒░▒░▒░▒▒▐░░░░░░░\n░░░░░░░▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒░▒░▒░▒░▒▒▒▌░░░░░░░\n░░░░░░░▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▒▄▒▒▐░░░░░░░░\n░░░░░░░░▀▄▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▄▒▒▒▒▌░░░░░░░░\n░░░░░░░░░░▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀░░░░░░░░░\n░░░░░░░░░░░░▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀░░░░░░░░░░░\n░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▀▀░░░░░░░░░░░░░░"
   
synonyms_for = (word) ->
  ["red", "orange", "yellow", "green", "blue", "indigo", "violet"]
  
shibe = (word) ->
  roll = Math.floor(Math.random() * 10)  
  console.log(roll)
  if roll == 6
    return "many #{word}s"    
  if roll == 7
    return "much #{word}"
  if roll == 8
    return "so #{word}"    
  if roll == 9
    return "such #{word}"
  return word
  
splice_in = (main_string, inner_string) ->
  if inner_string.length > main_string.length
    return inner_string
  highest_position = main_string.length - inner_string.length
  position = Math.floor(Math.random() * highest_position)
  replaced_string = main_string.slice(position, position + inner_string.length)
  if replaced_string.split('\n').length > 1
    return splice_in(main_string, inner_string)
  return main_string.slice(0, position) + inner_string + main_string.slice(position + inner_string.length)

module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.thesaurus_api = ""

  robot.respond /set thesaurus (.+)/i, (msg) ->
    robot.brain.data.thesaurus_api = msg.match[1].trim()
    msg.send "Setting thesaurus api to " + robot.brain.data.thesaurus_api

  robot.respond /get thesaurus/i, (msg) ->
    msg.send robot.brain.data.thesaurus_api

  robot.respond /doge (.+)/i, (msg) ->
    if robot.brain.data.thesaurus_api == ""
      msg.send "Wow."
      return
    word = msg.match[1].trim()
    doge = doge_image()
    for w in synonyms_for(word)
      doge = splice_in(doge, shibe(w))
      
    doge = splice_in(doge, "wow")
    msg.send "\n" + doge
