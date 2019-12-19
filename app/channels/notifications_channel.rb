class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "noti_channel_user_#{current_user.id}"
  end
end
