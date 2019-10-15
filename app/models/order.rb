class Order < ApplicationRecord
  ORDER_PARAMS = [:customer_id, :staff_id, :name, :phone, :address, :status,
    :person_number, :total_amount,
    table_ids: [], order_tables_attributes: [:order_id, :table_id]].freeze

  enum status: {pending: 0, accepted: 1, cancel: 2, paid: 3}

  belongs_to :customer, foreign_key: :customer_id,
    class_name: User.name, inverse_of: :customer_orders, optional: true
  belongs_to :staff, foreign_key: :staff_id,
    class_name: User.name, inverse_of: :staff_orders, optional: true

  has_many :order_tables, dependent: :destroy
  has_many :tables, through: :order_tables
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details

  validates :customer_id, numericality: {only_integer: true}, allow_nil: true
  validates :staff_id, numericality: {only_integer: true}, allow_nil: true
  validates :phone, numericality: {only_integer: true}, allow_nil: true
  validates :total_amount, numericality: {only_integer: true}, allow_nil: true
  validates :name, presence: true
  validates :person_number, presence: true,
    numericality: {greater_than_or_equal_to: Settings.min_book_size,
                   only_integer: true}
  validates :status, presence: true

  accepts_nested_attributes_for :order_tables, reject_if: :all_blank,
  allow_destroy: true
end
