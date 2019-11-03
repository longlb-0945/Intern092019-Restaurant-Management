class Admin::CategoriesController < AdminController
  before_action :not_login
  before_action :check_admin
  before_action :load_category, only: %i(edit update destroy)

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
      attach_image
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
      attach_image
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
    @categories = Category.search_name(params[:search])
                          .page(params[:page]).per Settings.pagenate_category
    if @categories.empty?
      flash.now[:danger] = I18n.t("no_result_found_category",
                                  search_text: params[:search])
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
      flash.now[:danger] = t "cannot_sort"
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

  def attach_image
    if params[:category][:image].blank?
      if params[:action].eql? "create"
        @category.image.attach(io: File.open(Rails.root
          .join("app", "assets", "images", "category.png")),
          filename: "category.png")
      end
    else
      @category.image.attach params[:category][:image]
    end
  end

  def search_flash_success
    flash.now[:success] =
      I18n.t("search_with_result_category",
             search_text: params[:search], count: @categories.size)
  end
end
