# A change to a people's score.

class Suggestion
  include DataMapper::Resource

  property :id, Serial
  property :creator, String, :required => true, :index => true
  property :lunch, String
  timestamps :created_at

  # Returns suggestion created by a Person.
  def self.given_by(nick)
    all(:creator => nick)
  end

  # Returns suggestion given between two dates.
  def self.between(start, stop)
    all(:created_at => start..stop)
  end
  
  # Returns suggestions in descending order of newness.
  def self.newest_first
    all(:order => [ :created_at.desc ])
  end
end
