class CategoriesController < ApplicationController
  before_action :load_category, only: :show

  def show
    params[:sort] ||= "order_name_asc"
    if Product::ORDER_SORT_PUBLIC_HASH.keys.include? params[:sort].to_sym
      sort_product
    else
      flash[:danger] = t "sort_param_fail"
      redirect_to category_path(@category)
    end
  end

  private
  def load_category
    @category = Category.find_by id: params[:id]
    return if @category

    flash[:danger] = t "category_not_found"
    redirect_to root_path
  end

  def sort_product
    @products = @category.products.enable.send(params[:sort])
                         .page(params[:page])
                         .per Settings.category_product_per_page
  end
end
