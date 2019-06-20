class Channel < ApplicationRecord
  belongs_to :game
  has_many :subscriptions
  has_many :users, through: :subscriptions
  validates :twitch_user_id, uniqueness: true


def self.get_live_streams(api_args: "first=100")
  #gets first 100 by default
  curr_live_channels = []
  @client_id = ENV["CLIENT_ID"]
  @bearer_token = ENV["BEARER_TOKEN"]
    @dummy_data = RestClient.get "https://api.twitch.tv/helix/streams?#{api_args}",  { 'Client-ID': "#{@client_id}", 'Authorization': "Bearer #{@bearer_token}"}
    @data = JSON.parse(@dummy_data)
    misc_game_id = Game.find_by(twitch_game_id: '0').id
    @data["data"].each do |twitch_channel|
      @channel = Channel.find_by(twitch_user_id: twitch_channel["user_id"])
      if !@channel
        if !twitch_channel["game_id"].empty?
          @game = Game.find{|game| game.twitch_game_id == twitch_channel["game_id"]}
          #creates a game if not found
          if !@game
            @specific_game = RestClient.get "https://api.twitch.tv/helix/games?id=#{twitch_channel["game_id"]}", { 'Client-ID': "#{@client_id}", 'Authorization': "Bearer #{@bearer_token}"}
            @specific_game_data = JSON.parse(@specific_game)["data"].first
            @game = Game.create(name: @specific_game_data["name"], category: @specific_game_data["name"], twitch_game_id: @specific_game_data["id"], box_art: @specific_game_data["box_art_url"])

          end
          @game_id = @game.id
        else
          #set twitch_game_id to 0 for misc
          @game_id = misc_game_id
        end
        #look for language
        @language = Language.find{|language| language.abbreviation == twitch_channel["language"]}
        @language = Language.find_by(name: "NA") if !@language

        #mod box art
        @box_art = twitch_channel["thumbnail_url"].split('{width}x{height}')
        @box_art[0] = @box_art[0] + '367x206'
        @final_box_art = @box_art.join

        @user_data = RestClient.get "https://api.twitch.tv/helix/users?id=#{twitch_channel["user_id"]}",  { 'Client-ID': "#{@client_id}", 'Authorization': "Bearer #{@bearer_token}"}
        @user_data = JSON.parse(@user_data)["data"]

        if !@user_data.empty?
          @found_user = @user_data.first
          @channel = Channel.new(twitch_user_login: @found_user["login"], twitch_user_id: twitch_channel["user_id"], name: twitch_channel["user_name"], title: twitch_channel["title"], language_id: @language.id, view_count: twitch_channel["viewer_count"], game_id: @game_id, status: twitch_channel["type"], box_art: @final_box_art, logo_url: @found_user["profile_image_url"])
        end

        if @channel.valid?
          @channel.save
          curr_live_channels << @channel
        end
      else
        curr_live_channels << @channel
      end
    end
    curr_live_channels
end

def self.get_streams_by_language(language: , num_of_streams: 8)
  self.get_live_streams(api_args: "first=#{num_of_streams}&language=#{language.abbreviation}")
end

  def self.search(array, search)
    if search
      channel = array.select{ |channel| channel.name.downcase.include?(search.downcase) }
    else
      array
    end
  end
end
