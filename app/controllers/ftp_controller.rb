class FtpController < ApplicationController
  def file
    user = User.find_by_email(params[:file].split(/\//)[4])
    if user
      file = params[:file]
      user.assets.create :data => File.new( file, 'r' )

    else
      Rails.logger.warn " ===================== params:\n #{params.inspect} \n ========================="
      Rails.logger.warn " ======================= User not found =================================="
    end



    render :json => {:status => 200}
  end

end