Rails.application.config.middleware.use OmniAuth::Builder do
  discord_oauth = Rails.application.credentials.discord
  github_oauth = Rails.application.credentials.github

  OmniAuth.config.on_failure = OmniauthController.action(:oauth_failure)

  provider :discord, discord_oauth.client_id, discord_oauth.secret, scope: 'email'
  provider :github, github_oauth.client_id, github_oauth.secret, scope: 'user, email'
end
