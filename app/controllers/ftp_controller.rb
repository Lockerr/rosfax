class FtpController < ApplicationController
  def file
    Rails.logger.warn " ===================== params:\n #{params.inspect} \n ========================="
    render :json => {:status => 200}
  end

end