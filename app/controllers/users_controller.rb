class UsersController < ApplicationController
  before_action :authenticate_user!, :find_user, :correct_user

  def show; end

  private
  def find_user
    return if @user = User.find_by(id: params[:id])

    flash[:danger] = t "user_not_found"
    redirect_to root_path
  end

  def correct_user
    redirect_to root_path unless current_user&.admin? || current_user == @user
  end
end
