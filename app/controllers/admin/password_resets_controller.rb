class Admin::PasswordResetsController < AdminController
  before_action :find_user, :valid_user,
                :check_expiration, only: %i(edit update)

  def new; end

  def create
    if @user = User.find_by(email: params[:password_reset][:email].downcase)
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "send"
      redirect_to root_url
    else
      flash.now[:danger] = t "email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      log_in @user
      flash[:success] = t "success_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    return if @user = User.find_by(email: params[:email])

    flash[:danger] = t "user_not_found"
    redirect_to root_path
  end

  def valid_user
    return if @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "user_invalid"
    redirect_to root_path
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "expired"
    redirect_to new_password_reset_url
  end
end
