class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :product, inverse_of: :order_details
end
