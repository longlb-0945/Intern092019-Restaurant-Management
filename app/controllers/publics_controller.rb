class PublicsController < ApplicationController
  skip_load_and_authorize_resource

  before_action :check_sort_option, only: %i(search)

  def search
    @products = @q.result.send(params[:sort]).page(params[:page])
                  .per Settings.pagenate_products

    render "publics/show"
  end

  private
  def check_sort_option
    params[:sort] ||= "order_name_asc"
    return if Product::ORDER_SORT_LIST.include? params[:sort]

    flash[:danger] = t "sort_param_fail"
    redirect_to root_path
  end
end
