class User < ApplicationRecord
  has_secure_password # does encryption and authentication
  has_many :subscriptions
  has_many :channels, through: :subscriptions
  belongs_to :language
  validates :username, presence: true
  validates :password, presence: true
  validates :username, uniqueness: true
  validates :language, presence: true


  def recommendChannel
    Channel.all.select do |channel|
      channel.language_id == self.language_id
    end[0..6]
  end

end
