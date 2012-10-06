# A person's nickname.

class Pseudonym
  include DataMapper::Resource
  
  property :id, Serial
  property :name, String, :required => true, :index => true
  property :person_id, Integer, :required => true, :index => true
  
  belongs_to :person
end
