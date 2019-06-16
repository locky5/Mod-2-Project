class Game < ApplicationRecord
  has_many :users, through: :subscriptions
  has_many :channels
end
