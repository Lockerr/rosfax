class ModelsController < ApplicationController
  def index_block
    unless params[:model_id]  and params[:model_id] == 'undefined'
      @model = Model.find(params[:model_id])
      render :layout => false
    else
      render :json => {:status => :not_found}
    end
  end
end