class SessionsController < ApplicationController
  skip_before_action :require_login, except: :destroy

  def new
    @user = User.new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to(:users, notice: 'Login successful')
    else
      flash.new[:alert] = 'Login failed'
      render action: 'new'
    end
  end

  def destroy
    logout
    flash[:success] = 'Logout successful'
    redirect_to '/sign_in'
  end
end
