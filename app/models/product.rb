class Product < ApplicationRecord
  PRODUCT_PARAMS = %i(name short_description category_id price stock).freeze

  enum status: {enable: 0, disable: 1}

  belongs_to :category

  has_many :order_details, dependent: :nullify, inverse_of: :product
  has_many :orders, through: :order_details
  has_many :rates, dependent: :nullify
  has_one_attached :image

  delegate :name, to: :category, prefix: true, allow_nil: true

  validates :name, presence: true
end
