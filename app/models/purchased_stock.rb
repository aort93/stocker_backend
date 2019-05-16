class PurchasedStock < ApplicationRecord
  belongs_to :user
  belongs_to :company
end
