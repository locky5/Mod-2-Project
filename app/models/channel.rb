class Channel < ApplicationRecord
  belongs_to :game
  has_many :subscriptions
  has_many :users, through: :subscriptions
  validates :name, uniqueness: true

  def self.alive
    Channel.select{|channel| channel.status == "live"}
  end

  def self.search(array, search)
    if search
      channel = array.select{ |channel| channel.name.downcase.include?(search.downcase) }
    else
      array
    end
  end
end
