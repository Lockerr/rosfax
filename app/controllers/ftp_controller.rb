class FtpController < ApplicationController
  def file
    file = File.new('/home/perekup/ftp/ttt@tt.t/2012-08-10/new_file.ttt')
    file.puts 'it`s a trap'

    user = User.find_by_email(params[:file].split(/\//)[4].gsub(/\\@/, '@'))

    Rails.logger.warn "User: #{user.email}" if user

    Rails.logger.warn params[:file].split(/\//)[4].inspect
    if user

      file = File.new(params[:file])

      asset = user.assets.new(:data => file)
      asset.save

      Rails.logger.warn asset.inspect

    else
      Rails.logger.warn " ===================== params:\n #{params.inspect} \n ========================="
      Rails.logger.warn " ======================= User not found =================================="
    end



    render :json => {:status => 200}
  end

end