class Game < ApplicationRecord
  has_many :channels
  validates :twitch_game_id, uniqueness: true

  def self.search(search)
    if search
      game = Game.select{ |game| game.name.include?(search.capitalize) }
      if game
        game.each do |game|
          game.name
        end
      else
        Game.all
      end
    else
      Game.all
    end
  end

end
