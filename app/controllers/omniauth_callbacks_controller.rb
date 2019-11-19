class OmniauthCallbacksController < ApplicationController
  include FacebookAdapter
  skip_before_action :require_login

  def method_missing(method, *args, &block)
    if OAuthIdentity.valid_provider?(method.to_s)
      self.call(:create_or_update, *args, &block)
    else
      super
    end
  end

  def create_or_update
    current_user_id = current_user&.id
    user_identity_pairer = UserIdentityPairer.new(request.env['omniauth.auth'], current_user_id)
    @user = user_identity_pairer.user
    @identity = user_identity_pairer.identity
    (@user && @identity) ? success(user_identity_pairer) : failure
  end

  def facebook
    @fb_adapter = FacebookCodeAdapter.new_from_code(params[:code])
  end

  private

  def success(user_identity_pairer)
    auto_login(@user) unless current_user
    flash.now[:success] = user_identity_pairer.flash_success_message
    render 'checks/index'
  end

  def failure

  end

end
