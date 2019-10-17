module CategoriesHelper
  def cate_sort_opt
    Category.sort_enums.reduce([]){|a, e| a << [I18n.t((e[0]).to_s), e[0]]}
  end
end
