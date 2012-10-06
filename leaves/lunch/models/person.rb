# An IRC member

class Person
  include DataMapper::Resource
  
  property :id, Serial
  property :server, String, :required => true, :unique_index => :server_and_name
  property :name, String, :required => true, :unique_index => :server_and_name
  property :authorized, Boolean, :required => true, :default => true
  
  has n, :suggestions
  has n, :pseudonyms
end
