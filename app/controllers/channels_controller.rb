require 'rest-client'
require 'JSON'

class ChannelsController < ApplicationController
  def index
    @client_id = "ustnqopkuzuzccqb0e4q0svq1185rr"
    @dummy_data = RestClient.get "https://api.twitch.tv/helix/streams?first=100",  { 'Client-ID': "#{@client_id}"}
    @dummy_data_games = RestClient.get "https://api.twitch.tv/kraken/games/top?limit=100",  { 'Client-ID': "#{@client_id}"}
    @data = JSON.parse(@dummy_data)
    @game_data = JSON.parse(@dummy_data_games)

    @data["data"].each do |twitch_channel|
      if twitch_channel["game_id"]
        @game = Game.find{|game| game.twitch_game_id == twitch_channel["game_id"]}
        if @game
          @game_id = @game.id
        else
          @specific_game = "https://api.twitch.tv/helix/games?id=#{twitch_channel["game_id"]}"
          Game.create(name: @specific_game["data"]["name"], category: @specific_game["data"]["name"], twitch_game_id: @specific_game["data"]["id"], box_art: @specific_game["data"]["box_art_url"])
        end
      else
          @game_id = "0"
      end
      @language = Language.find{|language| language.abbreviation == twitch_channel["language"]}
      @language = Language.find_by(name: "NA") if !@language
      @box_art = twitch_channel["thumbnail_url"].split('{width}x{height}')
      @box_art[0] = @box_art[0] + '500x600'
      @final_box_art = @box_art.join
      @new_channel = Channel.new(name: twitch_channel["user_name"], title: twitch_channel["title"], language_id: @language.id, view_count: twitch_channel["viewer_count"], game_id: @game_id, status: twitch_channel["type"], box_art: @final_box_art)
      if @new_channel.valid?
        @new_channel.save
      end
    end
    @channels_search = Channel.search(params[:search])
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
    @dummy_data = RestClient.get "https://api.twitch.tv/helix/streams?first=100",  { 'Client-ID': "#{@client_id}"}
    @data = JSON.parse(@dummy_data)
    @found_channel = @data["data"].find {|channel| channel["user_name"] == @channel.name}
    @channel.update(title: @found_channel["title"], view_count: @found_channel["viewer_count"])
  end

end
