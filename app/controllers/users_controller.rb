class UsersController < ApplicationController
  before_action :find_user, except: %i(index new create search sort)

  def index
    @users = User.page(params[:page]).per Settings.pagenate_user
    return if check_admin
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    attach_image
    if @user.save
      if logged_in? && current_user.admin?
        flash[:success] = t "create_user_succ"
        render :index
      else
        log_in @user
        flash[:success] = t "welcome"
        redirect_to root_path
      end
    else
      render :new
    end
  end

  def search
    @users = User.search(params[:search])
                 .page(params[:page]).per Settings.pagenate_user
    render :index
  end

  def sort
    if User.sort_enums.keys.include? params[:sort]
      @users = User.send(params[:sort])
                   .page(params[:page]).per Settings.pagenate_user
      render :index
    else
      flash[:danger] = t "cannot_sort"
      redirect_to users_path
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email,
                                 :password, :password_confirmation
  end

  def attach_image
    if params[:user][:image].blank?
      @user.image.attach io: File.open(Rails.root
        .join("app", "assets", "images", "default_user.png")),
        filename: "category.png"
    else
      @user.image.attach params[:user][:image]
    end
  end

  def find_user
    return if @user = User.find_by(id: params[:id])

    flash[:danger] = t "user_not_found"
    redirect_to root_path
  end

  def check_admin
    return true if current_user.admin?

    flash[:danger] = t "access_denied"
    redirect_to root_path
  end
end
