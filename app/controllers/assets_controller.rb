class AssetsController < ApplicationController

  def index
    if params[:attachable_type]
      @parent = params[:attachable_type].constantize.find(params[:attachable_id])
    else
      @parent = parent
    end
    @assets = @parent.assets
    
    if params[:section]
      assets = @parent.assets.where(:section => params[:section])
      render :json => assets.map{|i| i.attributes.merge(:src => i.url(:carousel))}
    else
      
      render json: @parent.assets.map{|i| i.attributes.merge(:src => i.url(:carousel))}
    end
    
  end
    
  def show 
    @report = Report.find(params[:report_id])
    
    if id = @report.send(params[:attribute])[params[:place]]
      image = Asset.find(id.first).url(:thumb)
    else
      image = 'https://s3-eu-west-1.amazonaws.com/rosfax/box.png'
    end
    render :json => image  
  end  

  def create
    if params[:asset]
      if report = Report.find(params[:report_id])
        asset = report.assets.create(params[:asset])
      end
      render :json => { :pic_path => asset.url.to_s , :name => asset.name, :id => asset.id }, :content_type => 'text/html'
    end
  end

  def update
    respond_to do |format|
      @asset = Asset.find(params[:id])
      if @asset.update_attributes(params[:asset])
        format.json { render json: :ok, status: :ok }
      else
        format.json { render json: @asset.errors, status: 422 }
      end
    end
  end


  def processed
    result = {}
    if assets = Asset.processed.where('id in (?)', params[:assets].uniq)
      assets.each {|asset| result[asset.id] = asset.url(params[:size].to_sym)}
    end
    render :json => {:assets => result, :keys => result.keys}
  end

  

  def parent
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end


end
