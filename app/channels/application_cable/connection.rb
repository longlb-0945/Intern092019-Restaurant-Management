module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      if env['warden'].user
        self.current_user = env['warden'].user
      else
        reject_unauthorized_connection
      end
    end
  end
end
