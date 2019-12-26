class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "noti_channel_user_#{current_user.id}"
    unless current_user.guest?
      stream_from "noti_channel_admin_staff"
    end
  end
end
