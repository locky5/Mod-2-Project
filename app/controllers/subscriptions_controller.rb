class SubscriptionsController < ApplicationController
  def index
  end

  def show
  end

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(user_id: params[:subscription][:user_id], channel_id: params[:subscription][:channel_id])
    if @subscription.valid?
      @subscription.save
      redirect_to profile_path(session[:user_id])
    else
      flash[:message] = 'Unable to subscribe'
      redirect_to channels_path
    end
  end

end
