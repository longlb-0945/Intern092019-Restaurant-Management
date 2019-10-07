class Category < ApplicationRecord
  has_many :products, dependent: :nullify
  has_one :picture, as: :target, dependent: :destroy
end
