class RegistrationsController < Devise::RegistrationsController
  def after_sign_up_path_for(resource)
	if resource.is_a?(User)
	  reports_path
	else
	  super
	end
  end	
end