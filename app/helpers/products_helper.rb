module ProductsHelper
  def load_categories
    Category.pluck :name, :id
  end

  def product_status_check product
    product.enable? ? :success : :danger
  end

  def product_statuses
    Product.statuses.keys.map{|w| [w.humanize, w]}
  end

  def product_sort_list select_options
    select_options.map{|key, value| [value, key]}
  end
end
