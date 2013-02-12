#encoding: utf-8
class ApplicationController < ActionController::Base
  # protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    if exception.action == :show and exception.subject.class == Report
      redirect_to report_access_path(exception.subject), flash[:notice] => 'Введите верный код доступа'
    else
       if request.env['HTTP_REFERER']
        redirect_to :back, :notice => exception.message
      else
        redirect_to root_path, :notice => exception.message
      end
    end
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
    @current_ability ||= Ability.new(current_user, request)
  end

end
