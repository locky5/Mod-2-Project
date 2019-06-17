require 'rest-client'
require 'JSON'

class GamesController < ApplicationController
  def index
    @client_id = "ustnqopkuzuzccqb0e4q0svq1185rr"
    @dummy_data = RestClient.get "https://api.twitch.tv/kraken/games/top?limit=100",  { 'Client-ID': "#{@client_id}"}
    @data = JSON.parse(@dummy_data)
    @data["top"].each do |game|
      Game.create(name: game["game"]["name"], category: game["game"]["popularity"])
    end
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

end
