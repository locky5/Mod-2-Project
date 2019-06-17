require 'rest-client'
require 'JSON'

class ChannelsController < ApplicationController
  def index
    @client_id = "ustnqopkuzuzccqb0e4q0svq1185rr"
    @dummy_data = RestClient.get "https://api.twitch.tv/helix/streams?first=100",  { 'Client-ID': "#{@client_id}"}
    @data = JSON.parse(@dummy_data)
    @data["data"].each do |channel|
      Channel.create(name: channel["user_name"], title: channel["title"], language: channel["language"], view_count: channel["viewer_count"], game_id: 1)
    end
    @channels = Channel.all
  end

  def show
    @channel = Channel.find(params[:id])
    @client_id = "ustnqopkuzuzccqb0e4q0svq1185rr"
    @dummy_data = RestClient.get "https://api.twitch.tv/helix/streams?first=100",  { 'Client-ID': "#{@client_id}"}
    @data = JSON.parse(@dummy_data)
    @found_channel = @data["data"].find {|channel| channel["user_name"] == @channel.name}
    @channel.update(name: @found_channel["user_name"], title: @found_channel["title"], language: @found_channel["language"], view_count: @found_channel["viewer_count"], game_id: 1)
  end

end
