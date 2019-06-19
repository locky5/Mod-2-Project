require 'rest-client'
require 'JSON'

class ChannelsController < ApplicationController
  def index
    curr_live_channels = Channel.get_live_streams
    @channels_search = Channel.search(curr_live_channels, params[:search])
    if params[:sort_by] == "name"
      @channels_search = @channels_search.sort_by{|channel| channel.name}
    end
  end

  def show
    @user_id = session[:user_id]
    @channel = Channel.find(params[:id])

    @subscribed = Subscription.find_by(user_id: @user_id, channel_id: @channel.id)
    @subscription = Subscription.new

    @client_id = "ustnqopkuzuzccqb0e4q0svq1185rr"
    @dummy_data = RestClient.get "https://api.twitch.tv/helix/streams?user_id=#{@channel.twitch_user_id}",  { 'Client-ID': "#{@client_id}"}
    @found_channel = JSON.parse(@dummy_data)["data"].first

    @channel.update(title: @found_channel["title"], view_count: @found_channel["viewer_count"]) if @found_channel
    @similar_streams = Channel.all.select {|channel| channel.game_id == @channel.game_id}.delete_if{|channel| channel == @channel}[0..7]
  end

end
