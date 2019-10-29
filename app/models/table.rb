class Table < ApplicationRecord
  TABLE_PARAMS = %i(table_number max_size status).freeze
  enum status: {available: 0, occupied: 1, disable: 2}

  has_many :order_tables, dependent: :nullify
  has_many :orders, through: :order_tables

  validates :table_number, presence: true, uniqueness: true,
    numericality: {greater_than_or_equal_to: Settings.min_table_number,
                   only_integer: true}
  validates :max_size, presence: true,
    numericality: {less_than_or_equal_to: Settings.max_table_size,
                   greater_than_or_equal_to: Settings.min_table_size,
                   only_integer: true}
  validates :status, presence: true

  scope :order_number, ->{order table_number: :asc}
  scope :usefull, ->{where(status: 0)}

  def order? order
    order == orders.first
  end
end
