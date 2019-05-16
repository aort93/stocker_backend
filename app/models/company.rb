class Company < ApplicationRecord
  has_many :purchased_stocks
  has_many :articles
  has_many :watchlists
end
