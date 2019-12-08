class UsersController < ApplicationController
  #TODO: show, delete, and destroy
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only:[:new, :create]

  def new
  end

  def create
    @user = User.new(user_params)

    if @user && @user.save
      login(@user.email, params[:user][:password], params[:remember_me])
      redirect_back_or_to(checks_path, notice: 'Signup successful')
    else
      flash.now[:alert] = 'Signup failed'
      render action: :new
    end
  end

  def edit
  end

  def update
    validate_password
    return if performed?
    if @user.update(user_params)
      redirect_to(edit_user_path(@user), notice: 'User updated successfully')
    else
      redirect_back_or_to(edit_user_path(@user), error: 'update failed')
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation, :remember_me)
  end

  def set_user
    @user = User.find(params[:id])
    unless @user == current_user
      render inline: '403 Forbidden', status: :forbidden
    end
  end

  def validate_password
    return if performed?
    pw = user_params[:password]
    unless pw == user_params[:password_confirmation]
      redirect_back_or_to(edit_user_path(@user), error: 'password and password confirmation must match')
    end
    unless @user.valid_password?(pw)
      redirect_back_or_to(edit_user_path(@user), error: 'invalid password')
    end
  end

end
