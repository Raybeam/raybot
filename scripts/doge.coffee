doge_image = ->
  "░░░░░░░░░░░░░░░▄░░░░░░░░░░░░░░▄░░░░░░░░░░\n░░░░░░░░░░░░░░▌▒█░░░░░░░░░░░▄▀▒▌░░░░░░░░░\n░░░░░░░░░░░░░░▌▒▒█░░░░░░░░▄▀▒▒▒▐░░░░░░░░░\n░░░░░░░░░░░░░▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐░░░░░░░░░\n░░░░░░░░░░░▄▄▀▒░▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐░░░░░░░░░\n░░░░░░░░░▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌░░░░░░░░░\n░░░░░░░░▐▒▒▒▄▄▒▒▒▒░░░▒▒▒▒▒▒▒▀▄▒▒▌░░░░░░░░\n░░░░░░░░▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐░░░░░░░░\n░░░░░░░▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄▌░░░░░░░\n░░░░░░░▌░▒▄██▄▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▌░░░░░░░\n░░░░░░▀▒▀▐▄█▄█▌▄░▀▒▒░░░░░░░░░░▒▒▒▐░░░░░░░\n░░░░░░▐▒▒▐▀▐▀▒░▄▄▒▄▒▒▒▒▒▒░▒░▒░▒▒▒▒▌░░░░░░\n░░░░░░▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒▒▒░▒░▒░▒▒▐░░░░░░░\n░░░░░░░▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒░▒░▒░▒░▒▒▒▌░░░░░░░\n░░░░░░░▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▒▄▒▒▐░░░░░░░░\n░░░░░░░░▀▄▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▄▒▒▒▒▌░░░░░░░░\n░░░░░░░░░░▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀░░░░░░░░░\n░░░░░░░░░░░░▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀░░░░░░░░░░░\n░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▀▀░░░░░░░░░░░░░░"

doge_indexes = ->
  [36, 137, 183, 211, 267, 337, 366, 445, 492, 571, 618, 691, 720, 802, 849, 934, 978, 1045, 1083, 1147, 1212, 1288, 1326, 1393, 1455, 1528, 1566, 1624, 1692, 1753, 1803, 1882, 1938, 2005, 2046, 2134, 2181, 2248]

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

splice_in_at = (main_string, inner_string, indexes) ->
  if inner_string.length > main_string.length
    return inner_string
  index = Math.floor(Math.random() * indexes.length)
  position = indexes[index]
  indexes.splice(index, 1)
  console.log index
  console.log position
  replaced_string = main_string.slice(position, position + inner_string.length)
  console.log replaced_string
  if replaced_string.split('\n').length > 1
    return splice_in_at(main_string, inner_string, indexes)
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
    indexes_to_use = doge_indexes().slice(0)
    synonyms_for(api_key, msg, word, (syns) ->
      for w in syns
        doge = splice_in_at(doge, shibe(w), indexes_to_use)
      doge = splice_in_at(doge, "wow", indexes_to_use)
      msg.send "\n" + doge
    )
