# Controller for the Server leaf.

class Controller < Autumn::Leaf
  
  # Typing "!about" displays some basic information about this leaf.
  
  def about_command(stem, sender, reply_to, msg)
    # This method renders the file "about.txt.erb"
  end

  def update_command(stem, sender, reply_to, msg)
    stem.message 'Updating TF2 server'
    `cd /home/tf2server && ./steamcmd.sh +runscript update_tf2.txt`
    stem.message 'Finished updating TF2 server'
  end
end
