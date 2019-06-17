class User < ApplicationRecord
  has_secure_password # does encryption and authentication
  has_many :channels, through: :subscriptions
  belongs_to :language
  validates :username, presence: true
  validates :password, presence: true
  validates :username, uniqueness: true
  validates :language, presence: true
end
