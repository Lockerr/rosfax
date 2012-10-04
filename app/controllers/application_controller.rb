class ApplicationController < ActionController::Base



  protect_from_forgery

  # def index
  #   warn params[:key].force_encoding("UTF-8").blank?
  # end
  
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
  
  def after_sign_in_path_for(resource_or_scope)
  	reports_path
  end
end
