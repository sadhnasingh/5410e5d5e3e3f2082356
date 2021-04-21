class User
  include Mongoid::Document
  field :firstName, type: String
  field :lastName, type: String
  field :email, type: String
end
