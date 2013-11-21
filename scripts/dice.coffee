# Description:
#   Utility commands surrounding rolling dice.
#
# Commands:
#   hubot roll <dice> - Rolls dice (1d20, 3d6 + 4, 2d8 - 1d5 + 1)
#   hubot stat - Generates a Attribute Stat (4d6, drop lowest)
#   hubot character - Generates Six Stats and Assigns them to Attributes
#   hubot choose <things> - Replies with a random selection from a space-delimited list of things

choose_from = (array) ->
  array[Math.floor(Math.random() * array.length)]
random_roll = (sides) ->
  Math.floor(Math.random() * sides) + 1

roll_one = (die_string) ->
  if die_string[0] == '-'
    return -1 * roll_one(die_string.substring(1))
  if die_string.indexOf('d') < 0
    return new Number(die_string)
  split_die = die_string.split('d')
  times = new Number(split_die[0])
  sides = new Number(split_die[1])
  amounts = (random_roll sides for i in [1..times])
  return amounts.reduce (t,s) -> t + s

roll = (dice_string) ->
  dice_string = dice_string.replace('-', '+-')
  bits = dice_string.split('+')
  return (roll_one bit for bit in bits).reduce (t, s) -> t + s

stat = ->
  rolls = (random_roll 6 for i in [1..4])
  sum = rolls.reduce (t, s) -> t + s
  lowest = Math.min.apply @, rolls
  return sum - lowest

module.exports = (robot) ->
  robot.respond /roll (\d*d\d+( ?[\+\-] ?(\d*d)?\d)*)/i, (msg) ->
    result = roll msg.match[1]
    msg.send result + " "

  robot.respond /stat/i, (msg) ->
    msg.send stat()

  robot.respond /character/i, (msg) ->
    races = ["Human", "Elven", "Dwarven", "Hobbit", "Orc"]
    my_race = choose_from races

    classes = ["Fighter", "Thief", "Wizard", "Priest", "Paladin", "Martial Artist"]
    my_class = choose_from classes

    attrs = (attr + ": " + stat() for attr in ["STR", "DEX", "CON", "INT", "WIS", "CHA"]).join "\n"
    msg.reply "A " + my_race + " " + my_class + "\n" + attrs
  
  robot.respond /choose (.+)/i, (msg) ->
    choices = (word for word in msg.match[1].split(' ') when word.length > 0)
    msg.reply(choose_from choices)

