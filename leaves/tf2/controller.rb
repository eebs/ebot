# Controller for the Tf2 leaf.

class Controller < Autumn::Leaf

  def initialize(opts={})
    super
    @gameme = GameMe.new
  end

  def about_command(stem, sender, reply_to, msg)
  end

  def tf2_command(stem, sender, reply_to, msg)
    @gameme.status
  end

  def players_command(stem, sender, reply_to, msg)
    playersXML = @gameme.players
    playerCount = playersXML.size
    players = []
    playersXML.each do |p|
        name = (p>'name').text
        kills = (p>'kills').text
        deaths = (p>'deaths').text
        players << name + '[' + kills + '/' + deaths + ']'
    end
    'Players: ' + playerCount.to_s + "\n " + players.join(', ')
  end

  def awards_command(stem, sender, reply_to, msg)
    name = msg
    # Use the sender's nick if they don't provide one
    name ||= sender[:nick]
    output = ''
    player, count = @gameme.player(name)

    return "Can't find '" + name + "'." unless count > 0

    playerName = (player>'name').text
    if(count > 1) then
      output += count.to_s + " players matching '" + name + "'\n"
      output += "Listing awards for '" + playerName + "', be more specific if this isn't you.\n"
    end

    awardsXML = @gameme.awards(player)

    if awardsXML.empty?
      output += "No awards for " + playerName + "."
    else
      awards = []
      awardsXML.each do |a|
        name = (a>'name').text
        count = (a>'count').text
        awards << playerName + ': ' + name + ' ( ' + count + ' )'
      end
      output += awards.join("\n")
    end
    output
  end
end
