::OmniAuthConfig = Proc.new do
  provider :facebook, Secrets.fb_app_id, Secrets.fb_app_secret
end
