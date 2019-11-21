class Users::RegistrationsController < Devise::RegistrationsController
  after_action :attach_regis, only: %i(create update)

  private

  def attach_regis
    @user.attach_image params, :user
  end
end
