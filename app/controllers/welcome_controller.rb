
class WelcomeController < ApplicationController

  
  def index
    @tx_id = params[:tx_id]
  end
  
  def get_tx_details
    @tx = Transaction.find(params[:id])
    render json: @tx
  end
  
  def get_utx
    @utx = Transaction.where({"blockHash" => {"$exists" => 0}}).limit(100)
    
  end
  
  def get_lineage
    client = Mongoid.client('default')
    tx_id = params[:id]
    
    agg = {
  "aggregate"=> "Transaction",
  "allowDiskUse" => true,
  "pipeline"=> [
    { "$match"=> { "_id"=> tx_id } },
    { "$project"=> {
      "input_addr"=>"$inputs.prev_out.addr"
    }
    },
  { "$unwind"=> "$input_addr" },
  { "$graphLookup"=>
    {
      "from"=> "Transaction",
      "startWith"=> "$input_addr",
      "connectFromField"=> "inputs.prev_out.addr",
      "connectToField"=> "out.addr",
      "as"=> "source",
      "maxDepth"=> 4,
      "depthField"=> "depth"
    }
    },
  { "$unwind"=> "$source" },
  { "$project"=>
    {
      "_id"=> 0,
      "toAddr"=>  "$source.out.addr",
      "fromtx"=> "$source._id",
      "address"=> "$source.inputs.prev_out.addr",
      "satoshi"=> "$source.inputs.prev_out.value",
      "depth"=> "$source.depth",
	  "time"=> "$time"
    }
    },
  { "$unwind"=> "$satoshi" },
  { "$unwind"=> "$address" },
  {
      "$group"=> {
        "_id" => "$depth",
        transactions: {
          "$push" => {
            "toAddr"=> "$toAddr",
            "fromtx"=> "$fromtx",
            "address"=> "$address",
            "satoshi"=> "$satoshi",
          }
        }
      }
    },
  { "$sort"=> { "_id"=> 1 } }
  ]
}
    
    result = client.command(agg)
  
    @lineage = result.documents[0]['result']

    nested = {}
    
    lin_length = @lineage.length    
    
    # @lineage.each do |doc|
    #
    #
    # end
    
    
    
    
  
  end
  
end