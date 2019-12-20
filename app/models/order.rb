class Order < ApplicationRecord
  ORDER_PARAMS = %i(name phone address person_number).freeze

  enum status: {pending: 0, accepted: 1, cancel: 2, paid: 3}

  belongs_to :customer, foreign_key: :customer_id,
    class_name: User.name, inverse_of: :customer_orders, optional: true
  belongs_to :staff, foreign_key: :staff_id,
    class_name: User.name, inverse_of: :staff_orders, optional: true

  has_many :order_tables, dependent: :destroy
  has_many :tables, through: :order_tables
  has_many :order_details, dependent: :destroy
  has_many :products, through: :order_details

  delegate :image, to: :customer, prefix: true, allow_nil: true
  delegate :image, to: :staff, prefix: true, allow_nil: true
  delegate :name, to: :customer, prefix: true, allow_nil: true
  delegate :name, to: :staff, prefix: true, allow_nil: true

  validates :customer_id, numericality: {only_integer: true}, allow_nil: true
  validates :staff_id, numericality: {only_integer: true}, allow_nil: true
  validates :name, presence: true
  validates :phone, presence: true
  validates :start_time, presence: true
  validate :start_time_around
  validates :address, presence: true
  validates :total_amount, numericality: {only_integer: true}, allow_nil: true
  validates :person_number, presence: true,
    numericality: {greater_than_or_equal_to: Settings.min_book_size,
                   only_integer: true}

  accepts_nested_attributes_for :order_tables, reject_if: :all_blank,
  allow_destroy: true
  accepts_nested_attributes_for :tables, reject_if: :all_blank

  scope :latest_orders,
        ->{where("created_at >= ?", Settings.latest_record.days.ago)}
  scope :order_by,
        ->(order_key, order_type){order("#{order_key} #{order_type}")}

  def table_to_available
    tables.each(&:available!)
  end

  private
  def start_time_around
    if !start_time || !start_time.hour.between?(8, 20)
      errors.add(:start_time, "Start hour must in 8 and 20!")
    end
  end
end
