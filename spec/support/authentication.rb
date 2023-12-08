# frozen_string_literal: true

module Authentication # :nodoc:
  def sign_in(user)
    session = { user_id: user.id }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)
    user
  end


  def logout
    session = { user_id: nil }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)
  end

  def current_user
    session.user_id
  end

  def get_omniauth_discord
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:discord] = OmniAuth::AuthHash.new(
      provider: 'discord',
      info: {
        email: 'foo@bar.com',
        name: 'John Snow',
        image: 'http://localhost:3000/assets/guestavatar1-d4811709e505098347222b78dad1a3266a06cb96c8ca107ef378b85699d8b0e2.png'
      }
    )
  end

  def get_omniauth_github
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = omni_auth_hash('github', 'foo@bar.com', 'John Snow', nil)
  end

  def get_bad_email_omniauth_github
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = omni_auth_hash('github', nil, 'John Snow', nil)
  end

  def get_bad_provider_omniauth_github
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = omni_auth_hash(nil, 'foo@bar.com', 'John Snow', nil)
  end

  def sign_in_omniauth(auth_hash)
    provider = auth_hash.provider

    email = auth_hash.info.email

    return nil unless email

    @user = User.find_or_create_by(email:)

    unless @user.persisted?
      case provider
      when 'discord'
        assign_user_variables(auth_hash.info.name, auth_hash.info.image)
      when 'github'
        assign_user_variables(auth_hash.info.name, auth_hash.info.image)
      else
        return nil
      end
    end

    sign_in @user
  end

  def omni_auth_hash(provider, email, name, image)
    OmniAuth::AuthHash.new(
      provider:,
      info: {
        email:,
        name:,
        image:
      }
    )
  end

  def assign_user_variables(username, url)
    @user.username = username
    @user.password = Digest::MD5.hexdigest(SecureRandom.hex)

    if url.present?
      downloaded_image = URI.parse(url).open
      @user.avatar.attach(io: downloaded_image, filename: 'foo.jpg')
    end

    return nil unless @user.save
  end

end

RSpec.configure do |config|
  config.include Authentication, type: :request
  config.include Authentication, type: :model
end
