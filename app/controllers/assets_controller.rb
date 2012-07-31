class AssetsController < ApplicationController
  def create
    if params[:asset]
      if report = Report.find(params[:report_id])
        asset = report.assets.create(params[:asset])
      end
      render :json => { :pic_path => asset.url.to_s , :name => asset.name }, :content_type => 'text/html'
    end

  end


end
