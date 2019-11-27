class Users::RegistrationsController < Devise::RegistrationsController
  require "open-uri"
  before_action :save_image_session, only: :create
  after_action :attach_regis, only: %i(create update)

  private

  def attach_regis
    if @user.uid.present? && action_name == "create"
      downloaded_image = open(@saved_image)
      @user.image.attach io: downloaded_image, filename: "avatar.jpg",
        content_type: downloaded_image.content_type
    else
      @user.attach_image params, :user
    end
  end

  def save_image_session
    @saved_image = session["devise.facebook_data"]["info"]["image"] if
      session["devise.facebook_data"].present?
  end
end
