class ProductsController < ApplicationController
  skip_load_and_authorize_resource

  before_action :check_sort_option, only: %i(index)

  def index
    @products = Product.available.send(params[:sort]).page(params[:page])
                       .per Settings.pagenate_products
  end

  def show
    @product = Product.find_by(id: params[:id])
    return if @product

    flash[:danger] = t "product_not_found"
    redirect_to root_path
  end

  private
  def check_sort_option
    params[:sort] ||= "order_name_asc"
    return if Product::ORDER_SORT_LIST.include? params[:sort]

    flash[:danger] = t "sort_param_fail"
    redirect_to root_path
  end
end
