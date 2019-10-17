module ProductsHelper
  def load_categories
    Category.pluck :name, :id
  end

  def product_status_check product
    product.enable? ? :success : :danger
  end
end
