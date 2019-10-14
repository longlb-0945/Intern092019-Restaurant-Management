class OrderDetail < ApplicationRecord
  ORDER_DETAIL_PARAMS = %i(order_id product_id price quantily amount).freeze

  belongs_to :order
  belongs_to :product, inverse_of: :order_details

  delegate :name, :picture_storage, to: :product, prefix: true, allow_nil: true

  validates :order_id, presence: true, numericality: {only_integer: true}
  validates :product_id, presence: true, numericality: {only_integer: true}
  validates :price, numericality: {only_integer: true}, allow_nil: true
  validates :quantily, numericality: {only_integer: true}, allow_nil: true
  validates :amount, numericality: {only_integer: true}, allow_nil: true
end
