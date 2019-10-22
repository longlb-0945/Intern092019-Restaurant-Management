class CategoriesController < ApplicationController
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

  def attach_image
    if params[:category][:image].blank?
      @category.image.attach(io: File.open(Rails.root
        .join("app", "assets", "images", "category.png")),
        filename: "category.png")
    else
      @category.image.attach(params[:category][:image])
    end
  end
end
