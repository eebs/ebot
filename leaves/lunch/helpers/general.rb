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

  def add_suggestion(sender, msg)
    return false if msg.empty? or sender.nil?
    Suggestion.create(:creator => sender[:nick], :lunch => msg)
  end

  def get_random_suggestion()
    Suggestion.first(:offset => rand(Suggestion.count))
  end
end
