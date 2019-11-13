class OrderDetail < ApplicationRecord
  ORDER_DETAIL_PARAMS = %i(order_id product_id price quantily amount).freeze

  belongs_to :order
  belongs_to :product, inverse_of: :order_details

  after_create :update_product_stock_after_create

  delegate :name, to: :product, prefix: true, allow_nil: true
  delegate :image, to: :product, prefix: true, allow_nil: true

  validates :order_id, presence: true, numericality: {only_integer: true}
  validates :product_id, presence: true, numericality: {only_integer: true}
  validates :price, numericality: {only_integer: true}, allow_nil: true
  validates :quantily, numericality: {only_integer: true}, allow_nil: true
  validates :amount, numericality: {only_integer: true}, allow_nil: true

  def update_product_stock_after_create
    new_stock = product.stock - quantily
    product.update(stock: new_stock)
  end

  def update_product_stock_after_cancel
    new_stock = product.stock + quantily
    product.update!(stock: new_stock)
  end
end
