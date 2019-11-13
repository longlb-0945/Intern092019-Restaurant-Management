class Admin::UsersController < AdminController
  before_action :find_user, except: %i(index new create search sort)

  def index
    @users = User.page(params[:page]).per Settings.pagenate_user
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    @user.attach_image params
    if @user.save
      if current_user.admin?
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

  def rev_user_status
    @user.enable? ? "disable" : "enable"
  end
end
