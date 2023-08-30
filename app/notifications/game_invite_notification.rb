# To deliver this notification:
#
# ParticipantNotification.with(post: @post).deliver_later(current_user)
# ParticipantNotification.with(post: @post).deliver(current_user)

class GameInviteNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def game_invite
    params[:message]
  end

  def whoGet
    game_invite.whoGet
  end

  def whoSent
    game_invite.whoSent
  end

  def game
    game_invite.game
  end

  # def destroy
  #   participant.destroy
  # end
  #
  # def url
  #   post_path(params[:post])
  # end
end
