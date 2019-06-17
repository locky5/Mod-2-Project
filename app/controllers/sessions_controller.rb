class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to profile_path(@user)
    else
      flash[:message] = @user.errors.full_messages[0]
      redirect_to "/login"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to "/login"
  end

end
