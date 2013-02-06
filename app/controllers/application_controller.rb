class ApplicationController < ActionController::Base
  # protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :back, :notice => exception.message
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
  	reports_path
  end

  def is_admin?
    return false unless current_user
    current_user.is_admin?
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, request.format)
  end

end
