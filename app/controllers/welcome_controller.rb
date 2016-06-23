class WelcomeController < ApplicationController
  
  def index
    
  end
  
  def get_tx_details
    @tx = Transaction.where(name: params[:id]).first
    render json: @tx
  end
  
end