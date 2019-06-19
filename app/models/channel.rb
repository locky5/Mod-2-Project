class Channel < ApplicationRecord
  belongs_to :game
  has_many :subscriptions
  has_many :users, through: :subscriptions
  validates :twitch_user_id, uniqueness: true

  def self.alive
    curr_live_channels
  end

  def self.search(array, search)
    if search
      channel = array.select{ |channel| channel.name.downcase.include?(search.downcase) }
    else
      array
    end
  end
end
