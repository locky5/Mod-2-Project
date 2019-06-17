class AddTwitchGameIdToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :twitch_game_id, :string
  end
end
