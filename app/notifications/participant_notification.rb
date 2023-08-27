# To deliver this notification:
#
# ParticipantNotification.with(post: @post).deliver_later(current_user)
# ParticipantNotification.with(post: @post).deliver(current_user)

class ParticipantNotification < Noticed::Base
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
  def participant
    params[:message]
  end

  def name
    participant.name
  end

  def game
    participant.game
  end

  # def destroy
  #   participant.destroy
  # end
  #
  # def url
  #   post_path(params[:post])
  # end
end
