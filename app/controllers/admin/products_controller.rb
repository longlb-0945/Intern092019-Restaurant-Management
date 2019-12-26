class Admin::ProductsController < AdminController
  before_action :load_product, only: %i(show edit update destroy)
  before_action ->{params_for_search Product}, only: %i(index search sort)
  load_and_authorize_resource :product

  def index
    order_key = params[:action_update] ? :updated_at_desc : :created_at_desc

    @products = Product.send(order_key).includes(:category)
                       .page(params[:page]).per Settings.pagenate_products
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    @product.attach_image params, :product
    if @product.save
      flash[:success] = t "create_product_suc"
      redirect_to admin_product_path(@product)
    else
      flash.now[:danger] = t "create_product_fail"
      render :new
    end
  end

  def show; end

  def edit
    respond_to :js
  end

  def update
    if @product.update product_params
      @product.attach_image params, :product
      flash[:success] = t "product_update_suc"
    else
      flash[:dander] = t "product_update_fail"
    end
    redirect_to admin_products_path(action_update: "update")
  end

  def destroy
    if @product.disable!
      flash[:success] = t "product_disable_suc"
    else
      flash[:danger] = t "product_disable_fail"
    end
    redirect_to admin_products_path
  end

  def sort
    if Product::ORDER_SORT_LIST.include? params[:sort]
      @products = Product.send(params[:sort])
                         .page(params[:page]).per Settings.pagenate_products
      render :index
    else
      flash[:danger] = t "sort_param_fail"
      redirect_to admin_products_path
    end
  end

  def search
    @products = @q.result
                  .page(params[:page]).per Settings.pagenate_products
    if @products.empty?
      flash.now[:danger] = t "no_result_found_product"
    else
      search_flash_success
    end
    render :index
  end

  private
  def product_params
    params.require(:product).permit Product::PRODUCT_PARAMS
  end

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product_not_found"
    redirect_to admin_products_path
  end

  def search_flash_success
    flash.now[:success] = t "search_with_result_product",
                            count: @products.size
  end
end
