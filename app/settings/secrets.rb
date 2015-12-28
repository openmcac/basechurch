class Secrets < Settingslogic
  source "#{Rails.root}/config/secrets.yml"
  namespace Rails.env
end
