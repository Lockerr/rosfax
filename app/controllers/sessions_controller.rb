class SessionsController < Devise::SessionsController
  def create
    resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    redirect_to reports_path
  end
end
