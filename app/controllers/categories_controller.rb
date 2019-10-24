class CategoriesController < ApplicationController
  before_action :not_login
  before_action :check_admin
  before_action :load_category, except: %i(index new create search sort)

  def index
    @categories = Category.page(params[:page]).per Settings.pagenate_category
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    attach_image
    if @category.save
      flash[:success] = t "create_category_suc"
      redirect_to categories_path
    else
      flash[:danger] = t "create_category_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @category.update category_params
      attach_image
      flash[:success] = t "update_category_suc"
      redirect_to categories_path
    else
      flash[:danger] = t "update_category_fail"
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:success] = t "cate_deleted"
    else
      flash[:danger] = t "cate_deleted_fail"
    end
    redirect_to categories_url
  end

  def search
    @categories = Category.search_name(params[:search])
                          .page(params[:page]).per Settings.pagenate_category
    render :index
  end

  def sort
    @categories = Category
    if Category.sort_enums.keys.include? params[:sort]
      @categories = @categories.send params[:sort]
    else
      flash[:danger] = t "cannot_sort"
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
    redirect_to categories_path
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
end
