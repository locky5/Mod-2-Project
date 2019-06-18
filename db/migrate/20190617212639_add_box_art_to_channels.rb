class AddBoxArtToChannels < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :box_art, :string
  end
end
