class Channel < ApplicationRecord
  belongs_to :game
  has_many :subscriptions
  has_many :users, through: :subscriptions
  validates :name, uniqueness: true


  def self.search(search)
    if search
      channel = Channel.select{ |channel| channel.name.include?(search.capitalize) }
      if channel
        channel.each do |channel|
          channel.name
        end
      else
        Channel.select{|channel| channel.status = "live"}
      end
    else
      Channel.select{|channel| channel.status = "live"}
    end
  end

end
