require 'rest-client'
require 'JSON'

class GamesController < ApplicationController
  def index
    @games = Game.search(params[:search])
    @client_id = "ustnqopkuzuzccqb0e4q0svq1185rr"
    @dummy_data = RestClient.get "https://api.twitch.tv/kraken/games/top?limit=100",  { 'Client-ID': "#{@client_id}"}
    @data = JSON.parse(@dummy_data)
  end

  def show
  end

  def new
  end

  def edit
  end
end
