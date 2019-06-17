class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?


  def current_user
    if session[:user_id]
      @user ||= User.find_by_id(session[:user_id])
    end
  end

  def logged_in?
    current_user != nil
  end

  def authorized?
    redirect_to signup unless logged_in?
  end
end
