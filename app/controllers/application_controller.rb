class ApplicationController < ActionController::Base
  #before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :require_login # defined by sorcery gem

  protected

=begin
  def configure_permitted_parameters
    attributes = [:name, :surname,:username, :email, :avatar]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end
=end

  def not_authenticated # called by require_login
    redirect_to '/sign_in', alert: 'Login required'
  end

end
