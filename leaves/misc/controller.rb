# Controller for the Tf2 leaf.

class Controller < Autumn::Leaf

  def zing_command(stem, sender, reply_to, msg)
    'http://eebsy.com/zing.mp3'
  end

  def did_receive_channel_message(stem, sender, channel, msg)
    if msg.include? 'ebot' and rand(1..100) == 1
      stem.message '/me blinks'
    end

    if sender[:nick] == 'ProdigyXP' and rand(1..25) == 1 and msg.length > 20
      stem.message 'Was that a pun?'
    end
  end

  def huggle_command(stem, sender, reply_to, msg)
    name = msg
    name ||= sender[:nick]
    '/me huggles ' + name
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
end
