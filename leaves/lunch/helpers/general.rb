# Utility methods used by Scorekeeper.

module GeneralHelper
  def parse_date(str)
    date = nil
    begin
      date = Chronic.parse(str, :context => :past, :guess => false)
    rescue NameError
      begin
        date = Date.parse(str)
      rescue ArgumentError
      end
    end
    return date
  end
  
  def find_range(date)
    start = nil
    stop = nil
    if date.kind_of? Range then
      start = date.first
      stop = date.last
    elsif date.kind_of? Time then
      start = date.to_date
      stop = date.to_date + 1
    else
      start = date
      stop = date + 1
    end
    return start, stop
  end
  
  def find_person(stem, nick)
    Person.all(:server => server_identifier(stem)).each do |person|
      return person if person.name.downcase == normalize(nick) or person.pseudonyms.collect { |pn| pn.name.downcase }.include? normalize(nick)
    end
    return nil
  end
  
  def find_in_channel(stem, channel, victim)
    stem.channel_members[channel].each do |name, privilege|
      return normalize(name, false) if normalize(name) == normalize(victim)
    end
    return victim
  end

  def normalize(nick, dc=true)
    dc ? nick.downcase.split(/\|/)[0] : nick.split(/\|/)[0]
  end
  
  def authorized?(creator)
    creator and creator.authorized?
  end
  
  def add_suggestion(stem, channel, creator, msg)
    return if msg.empty? or creator.nil?
    chan = Channel.find_or_create :server => server_identifier(stem), :name => channel
    chan.suggestions.create :creator => creator, :lunch => msg
  end

  def get_random_suggestion()
    Suggestion.first(:offset => rand(Suggestion.count))
  end
  
  def server_identifier(stem)
    "#{stem.server}:#{stem.port}"
  end
end
