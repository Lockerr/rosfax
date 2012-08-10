class FtpController < ApplicationController
  def file
    Rails.logger.warn " ===================== params:\n #{params.inspect} \n ========================="
    raise Error
  end

end