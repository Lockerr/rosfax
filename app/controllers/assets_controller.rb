class AssetsController < ApplicationController

  def index
    @parent = parent
    @assets = @parent.assets
    
    if params[:place]
      ids = @parent.send(params[:attribute]).values.flatten.map { |i| i.to_i }

      assets = Asset.where(:id => ids).map { |i| i.url(:carousel) }
      
      assets.push Asset.where(:id => @parent.send( params[:attribute] )[ params[:place] ].first).first.url(:carousel) if  @parent.send( params[:attribute] )[ params[:place] ]
      render :json => assets.reverse.uniq
    elsif parent.class == Point
      points = parent.report.points.where(:object => :element)
      point = parent
      assets = {}
      assets[:points] = {}
      assets[:point] = {}

      Asset.where(:id => point.images).map{|i| assets[:point][i.id] = i.url(:carousel)}
      Asset.where(:id => points.map(&:images).flatten.uniq).map{|i| assets[:points][i.id] = i.url(:carousel)}

      render :json => assets
    else
      assets = {}
      Asset.where(:id => @parent.assigned).map{|i| assets[i.id] = i.url(:carousel)}
      render json: assets
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
