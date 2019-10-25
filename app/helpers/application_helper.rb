module ApplicationHelper
  def load_cate
    @nav_categories = Category.all
  end
end
