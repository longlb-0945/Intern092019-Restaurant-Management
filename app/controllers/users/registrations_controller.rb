class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
    @user.attach_image params, :user
  end

  def update
    super
    @user.attach_image params, :user
  end
end
