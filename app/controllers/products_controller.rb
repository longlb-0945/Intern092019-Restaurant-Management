class ProductsController < ApplicationController
  before_action :load_product, only: %i(show)

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    @product.image.attach params[:product][:image]
    if @product.save
      flash[:success] = t "create_product_suc"
      redirect_to product_path(@product)
    else
      flash[:danger] = t "create_product_fail"
      render :new
    end
  end

  def show; end

  private
  def product_params
    params.require(:product).permit Product::PRODUCT_PARAMS
  end

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product_not_found"
    redirect_to products_path
  end
end
