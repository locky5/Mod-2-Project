class AddBoxArtToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :box_art, :string
  end
end
