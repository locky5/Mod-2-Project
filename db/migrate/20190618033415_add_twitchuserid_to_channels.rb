class AddTwitchuseridToChannels < ActiveRecord::Migration[5.2]
    def change
      add_column :channels, :twitch_user_id, :string
    end
  end
  