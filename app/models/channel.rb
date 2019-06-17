class Channel < ApplicationRecord
  belongs_to :game
  validates :name, uniqueness: true

  def self.search(search)
    if search
      channel = Channel.find_by(name: search)
      if channel
        self.where(channel_id: channel)
      else
        Channel.all
      end
    else
      Channel.all
    end
  end
end
