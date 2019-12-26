class Admin::UsersController < AdminController
  before_action :find_user, except: %i(index new create search sort)
  before_action ->{params_for_search User}, only: %i(index search sort)
  before_action :grant_update_role, only: %i(edit update)
  load_and_authorize_resource :user

  def index
    @users = User.page(params[:page]).per Settings.pagenate_user
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    @user.attach_image params, :user
    if @user.save
      flash[:success] = t "create_user_succ"
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:role].present? &&
       @user.update(role: params[:user][:role].to_i)
      flash[:success] = t "edit_user_succ"
      redirect_to admin_users_path
    else
      flash[:danger] = t "user_update_fail"
      render :edit
    end
  end

  def destroy
    if @user.send("#{rev_user_status}!")
      respond_to :js
    else
      flash[:danger] = t "user_delete_failed"
      redirect_to admin_users_path
    end
  end

  def search
    @users = @q.result
               .page(params[:page]).per Settings.pagenate_user
    if @users.empty?
      flash.now[:danger] =
        I18n.t("no_result_found_user",
               search_text: params[:search])
    else
      search_flash_success
    end
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
    redirect_to admin_dashboard_path
  end

  def rev_user_status
    @user.enable? ? "disable" : "enable"
  end

  def search_flash_success
    flash.now[:success] =
      I18n.t("search_with_result_user",
             search_text: params[:search], count: @users.size)
  end

  def grant_update_role
    return unless current_user.id == params[:id].to_i

    flash[:danger] = t "access_denied"
    redirect_to admin_dashboard_path
  end
end
