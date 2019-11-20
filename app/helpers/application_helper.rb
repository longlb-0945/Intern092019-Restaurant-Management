module ApplicationHelper
  def flaticon
    Settings.flaticon_arr.sample
  end

  def category_size_sub category
    category.size - Settings.one
  end
end
