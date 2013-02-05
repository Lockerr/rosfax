class ApplicationController < ActionController::Base
  # protect_from_forgery

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
  	reports_path
  end

  # if Rails.env.cucumber?
  #   def current_user
  #     return @current_user if defined?(@current_user)
  #     @current_user = cookies[:token] && User.find_by_token(cookies[:token])
  #   end
  # end
end
