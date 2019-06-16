require 'rest-client'
require 'JSON'

class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(session[:user_id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      redirect_to profile_path(session[:user_id])
    else
      flash[:message] = @user.errors.full_messages[0]
      redirect_to "/signup"
    end
  end

  def destroy
    @user = User.find(session[:user_id])
    @user.delete
    redirect_to "/users"
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :language)
  end

end
