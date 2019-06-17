class AddTypeToChannels < ActiveRecord::Migration[5.2]
  def change
    add_column :channels, :status, :string
  end
end
