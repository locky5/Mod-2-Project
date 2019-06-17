require 'rest-client'
require 'JSON'

class ChannelsController < ApplicationController
  def index
    @client_id = "ustnqopkuzuzccqb0e4q0svq1185rr"
    @dummy_data = RestClient.get "https://api.twitch.tv/helix/streams?first=100",  { 'Client-ID': "#{@client_id}"}
    @data = JSON.parse(@dummy_data)
    @data["data"].each do |twitch_channel|
      @game = Game.find{|game| game.twitch_game_id.to_s == twitch_channel["game_id"]}
      @game_id = @game ? @game.id : Game.find{|game| game.twitch_game_id = '0'}.id
      @language = Language.find{|language| language.abbreviation == twitch_channel["language"]}
      @new_channel = Channel.new(name: twitch_channel["user_name"], title: twitch_channel["title"], language_id: @language.id, view_count: twitch_channel["viewer_count"], game_id: @game_id, status: twitch_channel["type"])
      if @new_channel.valid?
        @new_channel.save
      # else
      #   @found_channel = Channel.find_by(name: twitch_channel["user_name"])
      #   @found_channel.update(name: twitch_channel["user_name"], title: twitch_channel["title"], language_id: @language.id, view_count: twitch_channel["viewer_count"], game_id: @game_id)
      end

    end
    @channels = Channel.search(params[:search])
  end

  def show
    @channel = Channel.find(params[:id])
    @client_id = "ustnqopkuzuzccqb0e4q0svq1185rr"
    @dummy_data = RestClient.get "https://api.twitch.tv/helix/streams?first=100",  { 'Client-ID': "#{@client_id}"}
    @data = JSON.parse(@dummy_data)
    @found_channel = @data["data"].find {|channel| channel["user_name"] == @channel.name}
    @channel.update(title: @found_channel["title"], view_count: @found_channel["viewer_count"])
  end

end
