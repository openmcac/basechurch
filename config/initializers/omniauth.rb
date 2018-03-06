::OmniAuthConfig = Proc.new do
  provider :facebook, ENV["fb_app_id"], ENV["fb_app_secret"]
end
