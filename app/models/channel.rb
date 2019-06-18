class Channel < ApplicationRecord
  belongs_to :game
  has_many :subscriptions
  has_many :users, through: :subscriptions
  validates :name, uniqueness: true


  def self.search(search)
    if search
      channel = Channel.select{ |channel| channel.name.downcase.include?(search.downcase) }
    else
      Channel.select{|channel| channel.status == "live"}
    end
  end

  def self.alive
    Channel.select{|channel| channel.status == "live"}
  end
end
