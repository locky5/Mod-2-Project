require 'rest-client'
require 'JSON'

class ChannelsController < ApplicationController
  def index
    @client_id = "ustnqopkuzuzccqb0e4q0svq1185rr"
    @dummy_data = RestClient.get "https://api.twitch.tv/helix/streams?first=100",  { 'Client-ID': "#{@client_id}"}

    @data = JSON.parse(@dummy_data)

    #look for game id
    misc_game_id = Game.find_by(twitch_game_id: '0').id
    @data["data"].each do |twitch_channel|
      if twitch_channel["game_id"].empty?
        @game = Game.find{|game| game.twitch_game_id == twitch_channel["game_id"]}
        #creates a game if not found
        if !@game
          @specific_game = RestClient.get "https://api.twitch.tv/helix/games?id=#{twitch_channel["game_id"]}",  { 'Client-ID': "#{@client_id}"}
          @specific_game_data = JSON.parse(@specific_game)["data"].first

          @game = Game.create(name: @specific_game_data["name"], category: @specific_game_data["name"], twitch_game_id: @specific_game_data["id"], box_art: @specific_game_data["box_art_url"])

        end
      else
        #set twitch_game_id to
        @game_id = misc_game_id
      end

      #look for language
      @language = Language.find{|language| language.abbreviation == twitch_channel["language"]}
      @language = Language.find_by(name: "NA") if !@language

      #mod box art url
      @box_art = twitch_channel["thumbnail_url"].split('{width}x{height}')
      @box_art[0] = @box_art[0] + '500x600'
      @final_box_art = @box_art.join

      @channel = Channel.find_by(name: twitch_channel["user_name"])
      if !@channel
        @channel = Channel.new(name: twitch_channel["user_name"], title: twitch_channel["title"], language_id: @language.id, view_count: twitch_channel["viewer_count"], game_id: @game.id, status: twitch_channel["type"], box_art: @final_box_art)
        if @channel.valid?
          @channel.save
        end
      else
        @channel.update(title: twitch_channel["title"], language_id: @language.id, view_count: twitch_channel["viewer_count"], game_id: @game.id, status: twitch_channel["type"], box_art: @final_box_art)
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
    @channel.update(title: @found_channel["title"], view_count: @found_channel["viewer_count"]) if @found_channel

    @similar_streams = Channel.all.select {|channel| channel.game_id == @channel.game_id}.delete_if{|channel| channel == @channel}[0..7]
  end

end
