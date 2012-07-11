class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    warn params[:key].force_encoding("UTF-8").blank?
  end
end
