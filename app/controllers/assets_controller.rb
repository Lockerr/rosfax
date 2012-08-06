class AssetsController < ApplicationController
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



end
