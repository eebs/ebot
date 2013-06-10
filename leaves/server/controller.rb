# Controller for the Server leaf.

class Controller < Autumn::Leaf
  
  # Typing "!about" displays some basic information about this leaf.
  
  def about_command(stem, sender, reply_to, msg)
    # This method renders the file "about.txt.erb"
  end

  def update_command(stem, sender, reply_to, msg)
    if File.exists? 'update_runfile.txt'
      'Server update in progress, please wait.'
    else
      File.open("update_runfile.txt", 'w') {|f| f.write($$) }
      stem.message 'Updating TF2 server'
      `cd /home/tf2server && ./steamcmd.sh +runscript update_tf2.txt`
      stem.message 'Finished updating TF2 server'
      File.delete 'update_runfile.txt'
    end
  end
end
