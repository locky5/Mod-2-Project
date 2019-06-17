class CreateChannels < ActiveRecord::Migration[5.2]
  def change
    create_table :channels do |t|
      t.string :name
      t.string :title
      t.integer :view_count
      t.belongs_to :game, foreign_key: true
      t.belongs_to :language, foreign_key: true

      t.timestamps
    end
  end
end
