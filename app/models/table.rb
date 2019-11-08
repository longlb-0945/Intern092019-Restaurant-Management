class Table < ApplicationRecord
  TABLE_PARAMS = %i(table_number max_size status).freeze
  ORDER_SORT_HASH = {"Status": "order_status",
                     "Table number low to high": "order_table_number_asc",
                     "Table number high to low": "order_table_number_desc",
                     "Max size low to high": "order_max_size_asc",
                     "Max size high to low": "order_max_size_desc"}.freeze

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

  ORDER_SORT_HASH.except(:Status).values.each do |sort|
    sort_split = sort.split("_")
    scope sort, ->{order("#{sort_split[1]}_#{sort_split[2]} #{sort_split[3]}")}
  end
  scope :created_at_desc, ->{order created_at: :desc}
  scope :order_number, ->{order table_number: :asc}
  scope :usefull, ->{where(status: 0)}
  scope :updated_at_desc, ->{order updated_at: :desc}

  class << self
    def order_status
      order("
        CASE
          WHEN status = 0 THEN '1'
          WHEN status = 1 THEN '2'
          WHEN status = 2 THEN '3'
        END")
    end
  end

  def order? order
    order == orders.first
  end
end
