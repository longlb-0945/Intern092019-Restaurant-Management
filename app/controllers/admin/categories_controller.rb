class Admin::CategoriesController < AdminController
  before_action :load_category, only: %i(edit update destroy)
  before_action ->{params_for_search Category}, only: %i(index search sort)

  def index
    order_key = params[:action_update] ? :updated_at_desc : :created_at_desc

    @categories = Category.send(order_key).page(params[:page])
                          .per Settings.pagenate_category
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      @category.attach_image params, :category
      flash[:success] = t "create_category_suc"
      redirect_to admin_categories_path
    else
      flash.now[:danger] = t "create_category_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @category.update category_params
      @category.attach_image params, :category
      flash[:success] = t "update_category_suc"
      redirect_to admin_categories_path(action_update: "update")
    else
      flash.now[:danger] = t "update_category_fail"
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "cate_deleted"
    else
      flash[:danger] = t "cate_deleted_fail"
    end

    redirect_to admin_categories_url
  end

  def search
    @categories = @q.result.page(params[:page]).per Settings.pagenate_category
    if @categories.empty?
      flash.now[:danger] = t "no_result_found_category"
    else
      search_flash_success
    end
    render :index
  end

  def sort
    @categories = Category
    if Category.sort_enums.keys.include? params[:sort]
      @categories = @categories.send params[:sort]
    else
      flash.now[:danger] = t "sort_param_fail"
    end
    @categories = @categories.page(params[:page]).per Settings.pagenate_category
    render :index
  end

  private

  def category_params
    params.require(:category).permit :name
  end

  def load_category
    @category = Category.find_by id: params[:id]
    return if @category

    flash[:danger] = t "category_not_found"
    redirect_to admin_categories_path
  end

  def search_flash_success
    flash.now[:success] = t "search_with_result_category",
             count: @categories.size
  end
end
