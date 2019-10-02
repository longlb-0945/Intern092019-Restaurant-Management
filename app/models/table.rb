class Table < ApplicationRecord
  enum status: {available: 0, occupied: 1, disable: 2}

  has_many :order_tables, dependent: :nullify
  has_many :orders, through: :order_tables
end
