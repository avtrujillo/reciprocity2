class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :require_login

  protected

  def configure_permitted_parameters
    attributes = [:name, :surname,:username, :email, :avatar]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end

  def not_authenticated
    redirect_to '/sign_in', alert: 'Login required'
  end

end
