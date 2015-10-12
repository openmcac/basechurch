Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Secrets.fb_app_id, Secrets.fb_app_secret
end
