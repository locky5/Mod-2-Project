class Channel < ApplicationRecord
  belongs_to :game
  has_many :subscriptions
  has_many :users, through: :subscriptions
  validates :twitch_user_id, uniqueness: true



  def self.get_streams_by_language(language)
    curr_live_channels = []
    @client_id = "ustnqopkuzuzccqb0e4q0svq1185rr"
    @dummy_data = RestClient.get "https://api.twitch.tv/helix/streams?first=8&language=#{language.abbreviation}",  { 'Client-ID': "#{@client_id}"}

    @data = JSON.parse(@dummy_data)
    misc_game_id = Game.find_by(twitch_game_id: '0').id
    @data["data"].each do |twitch_channel|
      if !twitch_channel["game_id"].empty?
        @game = Game.find{|game| game.twitch_game_id == twitch_channel["game_id"]}
        #creates a game if not found
        if !@game
          @specific_game = RestClient.get "https://api.twitch.tv/helix/games?id=#{twitch_channel["game_id"]}",  { 'Client-ID': "#{@client_id}"}
          @specific_game_data = JSON.parse(@specific_game)["data"].first

          @game = Game.create(name: @specific_game_data["name"], category: @specific_game_data["name"], twitch_game_id: @specific_game_data["id"], box_art: @specific_game_data["box_art_url"])

        end
      else
        #set twitch_game_id to 0 for misc
        @game_id = misc_game_id
      end
      @box_art = twitch_channel["thumbnail_url"].split('{width}x{height}')
      @box_art[0] = @box_art[0] + '500x600'
      @final_box_art = @box_art.join

      @channel = Channel.find_by(twitch_user_id: twitch_channel["user_id"])
      if !@channel
        @user_data = RestClient.get "https://api.twitch.tv/helix/users?id=#{twitch_channel["user_id"]}",  { 'Client-ID': "#{@client_id}"}
        @user_data = JSON.parse(@user_data)
        @found_user = @user_data["data"].first["login"]
     
        @channel = Channel.new(twitch_user_login: @found_user, twitch_user_id: twitch_channel["user_id"], name: twitch_channel["user_name"], title: twitch_channel["title"], language_id: language.id, view_count: twitch_channel["viewer_count"], game_id: @game.id, status: twitch_channel["type"], box_art: @final_box_art)

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

  def self.search(array, search)
    if search
      channel = array.select{ |channel| channel.name.downcase.include?(search.downcase) }
    else
      array
    end
  end
end
