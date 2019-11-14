class StaticPagesController < ApplicationController
  skip_load_and_authorize_resource
  before_action :check_sort_option, only: %i(search)

  def home
    @categories = Category.products_desc.take Settings.home_pick_item
    @products = Product.best_seller.take Settings.home_pick_item
  end

  def search
    @products = @q.result.send(params[:sort]).page(params[:page])
                  .per Settings.pagenate_products
  end

  private
  def check_sort_option
    params[:sort] ||= "order_name_asc"
    return if Product::ORDER_SORT_LIST.include? params[:sort]

    flash[:danger] = t "sort_param_fail"
    redirect_to root_path
  end
end
