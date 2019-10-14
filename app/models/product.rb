class Product < ApplicationRecord
  enum status: {enable: 0, disable: 1}

  belongs_to :category

  delegate :storage, to: :picture, prefix: true, allow_nil: true

  has_many :order_details, dependent: :nullify, inverse_of: :product
  has_many :orders, through: :order_details
  has_many :rates, dependent: :nullify
  has_one :picture, as: :target, dependent: :destroy
end
