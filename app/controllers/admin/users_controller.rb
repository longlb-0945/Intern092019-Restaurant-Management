class Admin::UsersController < AdminController
  before_action :authenticate_user!
  before_action :find_user, only: %i(show edit update correct_user)
  before_action :correct_user, only: %i(show edit update)

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
        redirect_to admin_users_path
      else
        log_in @user
        flash[:success] = t "welcome"
        redirect_to root_path
      end
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      if current_user.admin?
        set_role
      else
        flash[:success] = t "user_update_success"
        redirect_to @user
      end
    else
      flash[:danger] = t "user_update_fail"
      render :edit
    end
  end

  def correct_user
    redirect_to root_path unless current_user&.admin? || current_user?(@user)
  end

  def destroy
    if @user.disable!
      respond_to :js
    else
      flash[:danger] = t "user_delete_failed"
      redirect_to admin_users_path
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
      redirect_to admin_users_path
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email,
                                 :password, :password_confirmation
  end

  def find_user
    return if @user = User.find_by(id: params[:id])

    flash[:danger] = t "user_not_found"
    redirect_to root_path
  end

  def attach_image
    if params[:user][:image].blank?
      @user.image.attach io: File.open(Rails.root
        .join("app", "assets", "images", "default_user.png")),
        filename: "category.png"
    else
      @user.image.attach params[:user][:image]
    end
    redirect_to admin_users_path
  end
end
