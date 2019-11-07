class Product < ApplicationRecord
  ORDER_SORT_LIST = %w(order_name_asc order_name_desc
    order_category_asc order_category_desc
    order_price_asc order_price_desc order_stock_asc order_stock_desc).freeze
  ORDER_SORT_HASH = {"Name A->Z": "order_name_asc",
                     "Name Z->A": "order_name_desc",
                     "Category A->Z": "order_category_asc",
                     "Category Z->A": "order_category_desc",
                     "Price low to high": "order_price_asc",
                     "Price high to low": "order_price_desc",
                     "Stock low to high": "order_stock_asc",
                     "Stock high to low": "order_stock_desc"}.freeze
  ORDER_SORT_LIST_SCOPE = %w(order_name_asc order_name_desc
    order_price_asc order_price_desc order_stock_asc order_stock_desc).freeze
  PRODUCT_PARAMS = %i(name short_description category_id price stock).freeze

  enum status: {enable: 0, disable: 1}

  belongs_to :category

  has_one_attached :image

  has_many :order_details, dependent: :nullify, inverse_of: :product
  has_many :orders, through: :order_details
  has_many :rates, dependent: :nullify
  has_one_attached :image

  delegate :name, to: :category, prefix: true, allow_nil: true

  validates :image, content_type: {in: %w(image/jpeg image/gif image/png),
                                   message: I18n.t("valid_type_img")},
    size: {less_than: Settings.imgsize5.megabytes,
           message: I18n.t("valid_size_img")}
  validates :name, presence: true
  validates :category_id, numericality: {only_integer: true}, allow_nil: true
  validates :price, presence: true,
  numericality: {only_integer: true,
                 greater_than_or_equal_to: Settings.min_price_allow}
  validates :stock, numericality: {only_integer: true,
                                   greater_than_or_equal_to:
                                    Settings.min_stock_allow}

  ORDER_SORT_LIST_SCOPE.each do |sort|
    sort_split = sort.split("_")
    scope sort, ->{order("#{sort_split[1]} #{sort_split[2]}")}
  end
  scope :order_category_asc, ->{joins(:category).order("categories.name ASC")}
  scope :order_category_desc, ->{joins(:category).order("categories.name DESC")}
  scope :created_at_desc, ->{order("created_at DESC")}
  scope :updated_at_desc, ->{order("updated_at DESC")}
  scope :search_by_name,
        ->(text){where("LOWER(name) LIKE ?", "%" << text.downcase << "%")}
  scope :available, ->{where("status = 0 AND stock > 0")}
end
