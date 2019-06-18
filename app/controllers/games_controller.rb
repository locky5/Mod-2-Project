require 'rest-client'
require 'JSON'

class GamesController < ApplicationController
  def index
    @client_id = "ustnqopkuzuzccqb0e4q0svq1185rr"
    @dummy_data = RestClient.get "https://api.twitch.tv/kraken/games/top?limit=100",  { 'Client-ID': "#{@client_id}"}
    @data = JSON.parse(@dummy_data)
    @data["top"].each do |game|
      #create or update check for twitch_game_id uniqueness
      @new_game = Game.new(name: game["game"]["name"], category: game["game"]["popularity"], twitch_game_id: game["game"]["_id"], box_art: game["game"]["box"]["large"])
      if @new_game.valid?
        @new_game.save
      end
    end

    @game_search = Game.search(params[:search])
    if params[:sort_by] == "name"
      @game_search = @game_search.order(:name)
    end
  end

  def show
    @game = Game.find(params[:id])
    @channels = Channel.all
    @this_games_channels = @channels.select {|channel| channel["game_id"] == @game.id}

  end

end
