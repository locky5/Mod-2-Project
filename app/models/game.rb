class Game < ApplicationRecord
  has_many :users, through: :subscriptions
  has_many :channels

  def self.search(search)
    if search
      game = Game.find_by(name: search)
      if game
        self.where(game_id: game)
      else
        Game.all
      end
    else
      Game.all
    end
  end
end
