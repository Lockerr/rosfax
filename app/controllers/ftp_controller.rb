class FtpController < ApplicationController
  def file
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

  def update_eye_fi
    result = current_user.assets.where('id not in (?)', params[:ids]).map{|i| i.id}

    Rails.logger.info "result is: #{result}"

    render :json => result

  end


end