class OmniauthCallbacksController < ApplicationController


  def create_or_update
    @auth_hash = request.env['omniauth.auth']
    user_identity_pairer = UserIdentityPairer.new(@auth_hash, current_user.id)
    unless current_user
      auto_login(user_identity_pairer.user)
    end
    @identity = user_identity_pairer.identity
    flash.now[:success] = user_identity_pairer.flash_success_message
    render 'checks/index'
  end

  private

end
