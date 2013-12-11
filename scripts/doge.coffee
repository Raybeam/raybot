doge_image = ->
  "░░░░░░░░░░░░░░░▄░░░░░░░░░░░░░░▄░░░░░░░░░░\n░░░░░░░░░░░░░░▌▒█░░░░░░░░░░░▄▀▒▌░░░░░░░░░\n░░░░░░░░░░░░░░▌▒▒█░░░░░░░░▄▀▒▒▒▐░░░░░░░░░\n░░░░░░░░░░░░░▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐░░░░░░░░░\n░░░░░░░░░░░▄▄▀▒░▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐░░░░░░░░░\n░░░░░░░░░▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌░░░░░░░░░\n░░░░░░░░▐▒▒▒▄▄▒▒▒▒░░░▒▒▒▒▒▒▒▀▄▒▒▌░░░░░░░░\n░░░░░░░░▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐░░░░░░░░\n░░░░░░░▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄▌░░░░░░░\n░░░░░░░▌░▒▄██▄▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▌░░░░░░░\n░░░░░░▀▒▀▐▄█▄█▌▄░▀▒▒░░░░░░░░░░▒▒▒▐░░░░░░░\n░░░░░░▐▒▒▐▀▐▀▒░▄▄▒▄▒▒▒▒▒▒░▒░▒░▒▒▒▒▌░░░░░░\n░░░░░░▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒▒▒░▒░▒░▒▒▐░░░░░░░\n░░░░░░░▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒░▒░▒░▒░▒▒▒▌░░░░░░░\n░░░░░░░▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▒▄▒▒▐░░░░░░░░\n░░░░░░░░▀▄▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▄▒▒▒▒▌░░░░░░░░\n░░░░░░░░░░▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀░░░░░░░░░\n░░░░░░░░░░░░▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀░░░░░░░░░░░\n░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▀▀░░░░░░░░░░░░░░"

synonyms_for = (api, msg, word, callback) ->
  amount_to_use = 4 + Math.floor(Math.random() * 5)
  some_synonyms = []
  all_synonyms_for(api, msg, word, (synonyms) ->
    while amount_to_use > 0
      index = Math.floor(Math.random() * synonyms.length)
      some_synonyms.push(synonyms[index])
      synonyms.splice(index, 1)
      amount_to_use -= 1
    callback(some_synonyms)
  )


shibe = (word) ->
  roll = Math.floor(Math.random() * 10)
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


all_synonyms_for = (api, msg, word, callback) ->
  synonyms = []
  msg.http("http://words.bighugelabs.com/api/2/#{api}/#{word}/json").get() (err, res, body) ->
    if body? and body != ""
      data = JSON.parse(body)
      for type in ["noun", "verb", "adjective", "adverb"]
        attr = data[type]
        if attr?
          syns = attr.syn
          if syns?
            synonyms = synonyms.concat(syns)
      callback(synonyms)

module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.thesaurus_api = ""

  robot.respond /set thesaurus (.+)/i, (msg) ->
    robot.brain.data.thesaurus_api = msg.match[1].trim()
    msg.send "Setting thesaurus api to " + robot.brain.data.thesaurus_api

  robot.respond /get thesaurus/i, (msg) ->
    msg.send get_thesaurus_key

  robot.respond /all synonyms for (.+)/i, (msg) ->
    api_key = robot.brain.data.thesaurus_api
    if api_key == ""
      msg.send "No API Key."
      return
    word = msg.match[1].trim()
    all_synonyms_for(api_key, msg, word, (synonyms) ->
      msg.send synonyms.join(", ") + ":)"
    )

  robot.respond /some synonyms for (.+)/i, (msg) ->
    api_key = robot.brain.data.thesaurus_api
    if api_key == ""
      msg.send "No API Key."
      return
    word = msg.match[1].trim()
    synonyms_for(api_key, msg, word, (synonyms) ->
      msg.send synonyms.join(", ")
    )

  robot.respond /doge (.+)/i, (msg) ->
    api_key = robot.brain.data.thesaurus_api
    if api_key == ""
      msg.send "Wow."
      return
    word = msg.match[1].trim()
    doge = doge_image()
    synonyms_for(api_key, msg, word, (syns) ->
      for w in syns
        doge = splice_in(doge, shibe(w))
      doge = splice_in(doge, "wow")
      msg.send "\n" + doge
    )
