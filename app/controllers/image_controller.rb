class ImageController  < ApplicationController
  def destroy
    if params[:point_id]
      result =
      point = Point.find(params[:point_id])
      
      point.remove!(params[:id])
      
      result = Asset.find(point.images).first
      if result
        render :json => [result.id, result.url(params[:size])]
      else
        render :json => :empty_set
      end
    end
  end

  def index
    if params[:point_id]
      result = {}
      point = Point.find(params[:point_id])
      Asset.find(point.images).map{|i| result[i.id] = i.url(params[:size])}
      render :json => result
    end
  end
end
