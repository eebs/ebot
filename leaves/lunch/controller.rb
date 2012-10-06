# Controller for the Lunch leaf.

class Controller < Autumn::Leaf
  
  # Typing "!about" displays some basic information about this leaf.
  
  def about_command(stem, sender, reply_to, msg)
    # This method renders the file "about.txt.erb"
  end

  def lunch_command(stem, sender, reply_to, msg)
    if msg.nil? or msg.empty? then
        lunch = get_random_suggestion stem, reply_to
        if lunch.nil? or lunch.empty? then
            var :failed => true
            return
        end
        var :lunch => lunch
    else # adding a lunch suggestion
        parse_suggestion stem, sender, reply_to, msg
    end
  end

  private

  def parse_suggestion(stem, sender, reply_to, msg)
    creator = find_person(stem, sender[:nick])
    if creator.nil? then
        creator ||= Person.create(:server => server_identifier(stem), :name => sender[:nick])
    end

    unless authorized?(creator)
        var :unathorized => true
        return
    end

    add_suggestion stem, reply_to, creator, msg
    var :creator => creator
    var :msg => msg
  end
end
