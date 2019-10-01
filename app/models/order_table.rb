class OrderTable < ApplicationRecord
  belongs_to :order
  belongs_to :table
end
