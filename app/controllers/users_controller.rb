require 'rest-client'

class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find(session[:user_id])
    @client_id = "ustnqopkuzuzccqb0e4q0svq1185rr"
    @data = RestClient.get "https://api.twitch.tv/helix/streams?first=100",  { 'Client-ID': "#{@client_id}"}
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

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

end
