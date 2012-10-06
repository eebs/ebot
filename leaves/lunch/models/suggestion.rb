# A change to a people's score.

class Suggestion
  include DataMapper::Resource

  property :id, Serial
  property :creator_id, Integer, :required => true, :index => true
  property :channel_id, Integer, :required => true, :index => true
  property :lunch, String
  timestamps :created_at

  belongs_to :creator, :model => 'Person', :child_key => [ :creator_id ]
  belongs_to :channel

  # Returns suggestion created by a Person.
  def self.given_by(people)
    people = [ people ] unless people.kind_of?(Enumerable)
    people.map! { |person| person.kind_of?(Person) ? person.id : person }
    all(:creator_id => people)
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
