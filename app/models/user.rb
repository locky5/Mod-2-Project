class User < ApplicationRecord
  has_secure_password # does encryption and authentication
  has_many :subscriptions
  has_many :channels, through: :subscriptions
  belongs_to :language
  validates :username, presence: true
  validates :password, presence: true
  validates :username, uniqueness: true
  validates :language, presence: true

  def rec_channels_by_lang
    Channel.get_streams_by_language(language: self.language)
  end

  #can refactor to weight the games
  def get_top_games
    game_count = {}
    self.subscriptions.each do |subscription|
      game_id = Channel.find(subscription.channel_id).game_id
      game_count[game_id] ||= 0
      game_count[game_id] += 1
    end
    game_count.sort_by {|key, value| value}.reverse.to_h.keys
  end

  def rec_channels_by_sub
    #only account for top 2 games now
    #game_counts = self.get_top_games.count >= 2 ? 
    top_games = self.get_top_games
    channels = []
    if self.get_top_games.count == 1
      t_game_id = Game.find(top_games[0]).twitch_game_id
      channels << Channel.get_live_streams(api_args: "first=8&game_id=#{t_game_id}") 
    else
      top_games[0..1].each do |game|
        t_game_id = Game.find(game).twitch_game_id
        channels << Channel.get_live_streams(api_args: "first=4&game_id=#{t_game_id}")      
      end
    end
    channels.flatten(1)
  
  end

end
