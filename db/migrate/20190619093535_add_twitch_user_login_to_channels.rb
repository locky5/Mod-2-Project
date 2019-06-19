class AddTwitchUserLoginToChannels < ActiveRecord::Migration[5.2]
    def change
      add_column :channels, :twitch_user_login, :string
    end
  end
  