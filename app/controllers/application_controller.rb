class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?

  around_action :set_current_admin_user

  def set_current_admin_user
    Current.admin_user = current_admin_user
    yield
  ensure
    # to address the thread variable leak issues in Puma/Thin webserver
    Current.admin_user = nil
  end

  protected

  def configure_permitted_parameters
    #devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
	    user_params.permit(:username, :email, :mobile, :password, :remember_me)
	  end
  end
end