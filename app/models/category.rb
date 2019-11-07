class Category < ApplicationRecord
  enum sort_enum: {default: 0, name_asc: 1, name_desc: 2,
                   create_at_asc: 3, create_at_desc: 4}

  has_many :products, dependent: :nullify
  has_one_attached :image

  scope :created_at_desc, ->{order created_at: :desc}
  scope :create_at_asc, ->{order created_at: :asc}
  scope :default, ->{order id: :asc}
  scope :name_desc, ->{order name: :desc}
  scope :name_asc, ->{order name: :asc}
  scope :search_name, ->(name){where "name LIKE ?", "%#{name}%"}
  scope :updated_at_desc, ->{order updated_at: :desc}

  validates :name, presence: true, uniqueness: true
  validates :image, content_type: {in: %w(image/jpeg image/gif image/png),
                                   message: I18n.t("valid_type_img")},
    size: {less_than: Settings.imgsize5.megabytes,
           message: I18n.t("valid_size_img")}
end
