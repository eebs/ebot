# Controller for the Lunch leaf.

class Controller < Autumn::Leaf
  
  # Typing "!about" displays some basic information about this leaf.
  
  def about_command(stem, sender, reply_to, msg)
    # This method renders the file "about.txt.erb"
  end

  def lunch_command(stem, sender, reply_to, msg)
    if msg.nil? or msg.empty? then
        lunch = get_random_suggestion
        if lunch.nil? or lunch.empty? then
            var :failed => true
            return
        end
        var :lunch => lunch
    else # adding a lunch suggestion
        parse_suggestion sender, msg
        render :add
    end
  end

  private

  def parse_suggestion(sender, msg)
    unless add_suggestion sender, msg
      var :failed => true
    end
  end
end
