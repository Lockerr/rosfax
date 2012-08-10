class FtpController < ApplicationController
  def file
    user = User.find_by_email(params[:file].split(/\//)[4])

    Rails.logger.warn params[:file].split(/\//)[4].inspect
    if user

      file = File.new(params[:file].gsub('@', '\\@')

      asset = user.assets.new :data => file
      asset.save

      Rails.logger.warn asset.inspect

    else
      Rails.logger.warn " ===================== params:\n #{params.inspect} \n ========================="
      Rails.logger.warn " ======================= User not found =================================="
    end



    render :json => {:status => 200}
  end

end