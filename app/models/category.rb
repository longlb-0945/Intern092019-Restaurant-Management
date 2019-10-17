class Category < ApplicationRecord
  has_many :products, dependent: :nullify
  has_one_attached :image
end
