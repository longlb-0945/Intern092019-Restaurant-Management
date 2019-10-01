class Order < ApplicationRecord
  enum status: {pending: 0, accepted: 1, cancel: 2, paid: 3}

  belongs_to :customer, foreign_key: :customer_id,
    class_name: User.name, inverse_of: :orders
  belongs_to :staff, foreign_key: :staff_id,
    class_name: User.name, inverse_of: :orders

  has_many :order_tables, dependent: :nullify
  has_many :tables, through: :order_tables
  has_many :order_details, dependent: :nullify
  has_many :products, through: :order_details
end
