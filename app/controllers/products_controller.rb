class Admin::ProductsController < AdminController
  before_action :authenticate_user!, except: :show
  before_action :check_admin, except: :show
  before_action :load_product, only: %i(show edit update destroy)

  def index
    @products = Product.includes(:category).page(params[:page])
                       .per Settings.pagenate_products
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    product_image_attach
    if @product.save
      flash[:success] = t "create_product_suc"
      redirect_to product_path(@product)
    else
      flash[:danger] = t "create_product_fail"
      render :new
    end
  end

  def show; end

  def edit
    respond_to :js
  end

  def update
    if @product.update product_params
      product_image_attach
      flash[:success] = t "product_update_suc"
    else
      flash[:dander] = t "product_update_fail"
    end
    respond_to do |format|
      format.js{render js: "location.reload();"}
    end
  end

  def destroy
    if @product.disable!
      flash[:success] = t "product_disable_suc"
    else
      flash[:danger] = t "product_disable_fail"
    end
    redirect_to products_path
  end

  def sort
    if Product::ORDER_SORT_LIST.include? params[:product_sort_type]
      @products = Product.send(params[:product_sort_type])
                         .page(params[:page]).per Settings.pagenate_products
      render :index
    else
      flash[:danger] = t "sort_param_fail"
      redirect_to admin_products_path
    end
  end

  def search
    @products = Product.search_by_name(params[:product_search])
                       .page(params[:page]).per Settings.pagenate_products
    if @products
      render :index
    else
      flash[:danger] = t "product_search_fail"
      redirect_to products_path
    end
  end

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

  def product_image_attach
    if params[:product][:image].blank?
      if params[:action].eql? "create"
        @product.image.attach(io: File.open(Rails.root
            .join("app", "assets", "images", "default.png")),
              filename: "default.png")
      end
    else
      @product.image.attach(params[:product][:image])
    end
  end
end
