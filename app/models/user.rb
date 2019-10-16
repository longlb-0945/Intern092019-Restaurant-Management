class User < ApplicationRecord
  enum role: {admin: 0, staff: 1, guest: 2}
  enum status: {enable: 0, disable: 1}

  has_many :rates, dependent: :nullify
  has_many :customer_orders, foreign_key: :customer_id,
    class_name: Order.name, dependent: :destroy,
    inverse_of: :customer
  has_many :staff_orders, foreign_key: :staff_id,
    class_name: Order.name, dependent: :destroy,
    inverse_of: :staff
  has_one_attached :image

  validates :image, content_type: {in: %w(image/jpeg image/gif image/png),
                                   message: I18n.t("valid_type_img")},
    size: {less_than: Settings.imgsize5.megabytes,
           message: I18n.t("valid_size_img")}
end
