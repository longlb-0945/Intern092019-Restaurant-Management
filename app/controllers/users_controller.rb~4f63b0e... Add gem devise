class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user, only: %i(show edit update correct_user)
  before_action :correct_user, only: %i(show edit update)

  def show; end

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
    redirect_to root_path unless current_user&.admin? || current_user == @user
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
  end
end
