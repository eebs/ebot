# Controller for the Tf2 leaf.

require 'open-uri'
class Controller < Autumn::Leaf
  before_filter :base_url

  # Typing "!about" displays some basic information about this leaf.

  def about_command(stem, sender, reply_to, msg)
    # This method renders the file "about.txt.erb"
  end

  def someone_did_leave_channel(stem, person, channel)
    stem.message 'Good riddance, I never really liked ' + person[:nick] + ' anyway'
  end

  def did_start_up
    stems.message "Hello!"
  end

  def tf2_command(stem, sender, reply_to, msg)
    url = @base_url + 'serverinfo/' + @server_ip
    doc = Nokogiri::XML(open(url))
    server = doc>'gameME'>'serverinfo'>'server'
    map = (server>'map').text
    act = (server>'act').text
    max = (server>'max').text
    map + ': ' + act + '/' + max
  end

  def players_command(stem, sender, reply_to, msg)
    url = @base_url + 'serverinfo/' + @server_ip + '/players'
    doc = Nokogiri::XML(open(url))
    playersXML = doc>'gameME'>'serverinfo'>'server'>'players'>'player'
    playerCount = playersXML.size
    players = Array.new
    playersXML.each do |p|
        name = (p>'name').text
        kills = (p>'kills').text
        deaths = (p>'deaths').text
        players << name + '[' + kills + '/' + deaths + ']'
    end
    'Players: ' + playerCount.to_s + "\n " + players.join(', ')
  end

  def huggle_command(stem, sender, reply_to, msg)
    name = msg
    name ||= sender[:nick]
    '/me huggles ' + name
  end

  def awards_command(stem, sender, reply_to, msg)
    # Clear the cached player lsit
    @playerlist = nil
    name = msg
    # Use the sender's name if they don't provide one
    name ||= sender[:nick]
    output = ''
    count = get_players_by_name_count(name)
    players = get_players_by_name(name)
    return "Can't find '" + name + "'." unless count.to_i > 0
    player = players.first
    playerName = (player>'name').text
    if(count.to_i > 1) then
        output += count + " players matching '" + name + "'\n"
        output += "Listing award for '" + playerName + "', be more specific if this isn't you.\n"
    end
    output += get_awards_output(player)
  end

  def roll_command(stem, sender, reply_to, msg)
    parts = msg.split
    return "Invalid entry" if parts.size != 2
    output = Array.new
    dice = parts[0]
    sides = parts[1]
    dice.to_i.times do |x|
        output << Random.rand(1..sides.to_i) unless sides.to_i < 1
    end
    output.join(', ')
  end

  protected

  def get_awards_output(player)
    playerName = (player>'name').text
    steamID = (player>'uniqueid').text
    url = @base_url + 'playerinfo/tf/' + steamID + '/awards'
    doc = Nokogiri::XML(open(url))
    player = doc>'gameME'>'playerinfo'>'player'
    awards = player>'awards'>'award'
    todaysAwards = Array.new
    awards.each do |a|
        awardDate = DateTime.parse((a>'date').text)
        if(awardDate == DateTime.yesterday) then
            name = (a>'name').text
            count = (a>'count').text
            todaysAwards << playerName + ': ' + name + ' ( ' + count + ' )'
        end
    end
    return "No awards for " + playerName + "." if todaysAwards.empty?
    todaysAwards.join("\n")
  end

  def get_players_by_name(name)
    @playerlist ||= get_playerlist(name)
    @playerlist>'player'
  end

  def get_players_by_name_count(name)
    @playerlist ||= get_playerlist(name)
    count = @playerlist>'pagination'>'totalcount'
    count.text
  end

  def get_playerlist(name)
    name = URI.escape(name)
    url = @base_url + 'playerlist/tf/name/' + name
    doc = doc = Nokogiri::XML(open(url))
    doc>'gameME'>'playerlist'
  end

  def base_url_filter(stem, channel, sender, command, msg, opts)
    @base_url ||= 'http://teamfuncom2.gameme.com/api/'
    @server_ip ||= '173.234.159.103:27018'
  end
end
