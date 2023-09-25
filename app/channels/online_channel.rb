class OnlineChannel < Turbo::StreamsChannel

  def subscribed
    current_user&.online!
    current_user&.update!(last_time_online_at: Time.current)
    super
  end

  def unsubscribed
    puts current_user
    puts current_user
    puts current_user
    puts current_user
    puts current_user
    puts current_user
    puts current_user
    puts current_user
    puts current_user
    puts current_user
    puts current_user
    puts current_user
    current_user&.offline!
    super
  end
end
