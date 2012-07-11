class AssetsController < ApplicationController
  def create
    if params[:asset]
      if report = Report.find(params[:report_id])
        #asset = Asset.create(:data => params[:asset][:Filedata], :attachable_id => report.id, :attachable_type => 'report')
        #report.assets.push asset
        asset = Asset.new params[:asset]
        asset.attachable_id = report.id
        asset.attachable_type = 'report'
        asset.save
      end
      render :json => { :pic_path => asset.url.to_s , :name => asset.name }, :content_type => 'text/html'
      #Checkin.first.assets.push Asset.create(:data => params[:Filedata])
    end

  end


end
