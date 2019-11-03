class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    @user.deliver_password_reset_instructions! if @user
    redirect_to('/sign_in', notice: 'Instructions have been sent to your email')
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    not_authenticated if @user.blank?
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(@token)

    if @user.blank?
      not_authenticated
    else
      change_password
    end
  end

  private

  def change_password
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password!(params[:user][:password])
      redirect_to root_path, notice: 'Password was successfully updated'
    else
      render action: 'edit'
    end
  end

end
