module CategoriesHelper
  def cate_sort_opt
    Category.sort_enums.reduce([]){|a, c| a << [I18n.t((c[0]).to_s), c[0]]}
  end
end
