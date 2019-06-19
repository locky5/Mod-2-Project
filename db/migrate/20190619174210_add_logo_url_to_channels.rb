class AddLogoUrlToChannels < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :logo_url, :string
  end
end
