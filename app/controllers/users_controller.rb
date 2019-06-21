require 'rest-client'
require 'JSON'

class UsersController < ApplicationController

  def index
    @users = User.all

    @user_search = User.search(params[:search])
    if params[:sort_by] == "username"
      @game_search = @game_search.order(:username)
    end
  end

  def show
    @user = User.find(params[:id])
    @main = User.find(session[:user_id])
    @languages = Language.all
  end

  def new
    @user = User.new
    @languages = Language.all
  end

  def edit
    @user = User.find(params[:id])
    if @user.id == session[:user_id]
      @languages = Language.all
    else
      redirect_to '/not_found'
    end
  end

  def update
    @user = User.find(params[:id])
    #@user.avatar.attach(io: File.open('app/assets/images/Parrot.jpeg'), filename: 'Parrot.jpeg', content_type: 'image/jpeg')
    @user.update(user_params)

    if @user.valid?
      session[:user_id] = @user.id
      redirect_to profile_path(@user)
    else
      flash[:message] = @user.errors.full_messages[0]
      redirect_to edit_path(session[:user_id])
    end
  end

  def create
    @user = User.new(user_params)
    #@user.avatar.attach(io: File.open('app/assets/images/Parrot.jpeg'), filename: 'Parrot.jpeg', content_type: 'image/jpeg')
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

    @user.subscriptions.delete_all
    @user.delete
    session[:user_id] = nil
    redirect_to "/"
  end

  def buddy
    @user = User.find(session[:user_id])
    @friend = User.find(params[:id])

    if @user.friendships.include?(@friend)
      @user.remove_friend(@friend)
    else
      @user.add_friend(@friend)
    end
    redirect_to profile_path(@friend)
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :language_id, :avatar)
  end

end
