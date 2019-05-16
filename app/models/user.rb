class User < ApplicationRecord
  has_many :watchlists
  has_many :purchased_stocks
  has_many :invested_companies, through: :purchased_stocks, source: :company
  has_many :watced_companies, through: :watchlists, source: :company

  validates :username, uniqueness: true
  has_secure_password
end
