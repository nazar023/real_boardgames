module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = verified_user
    end

    private

    def verified_user
      if user = User.find_by(id: cookies.encrypted[:user_id])
        user
      else
        reject_unauthorized_connection
        # nil
      end
    end
  end
end
