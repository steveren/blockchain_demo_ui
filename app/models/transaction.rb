class Transaction
  include Mongoid::Document
  store_in collection: 'Transaction', database: 'bitcoin'
  
  field :out, type: Array
  field :relayed_by, type: String
  field :inputs, type: Array
  field :ver, type: Integer
  field :lock_time, type: Integer
  field :size, type: Integer
  field :time, type: Integer
  field :tx_index, type: Integer
  field :vin_sz, type: Integer
  field :vout_sz, type: Integer
end