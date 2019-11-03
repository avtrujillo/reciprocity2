class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def new

  end

  def create
    @user = User.create(user_params)

    if @user
      redirect_back_or_to(:users, notice: 'Signup successful')
    else
      flash.now[:alert] = 'Signup failed'
      render action: 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
