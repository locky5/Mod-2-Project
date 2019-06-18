class Game < ApplicationRecord
  has_many :channels
  validates :twitch_game_id, uniqueness: true

  def self.search(search)
    if search
      Game.select{ |game| game.name.downcase.include?(search.downcase) }
    else
      Game.all
    end
  end

end
