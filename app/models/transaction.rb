class Transaction
  include Mongoid::Document
  field :name, type: String
  field :address, type: String
  field :satoshi, type: Integer

end