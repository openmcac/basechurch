class Secrets < Settingslogic
  source "#{Rails.root}/config/#{Rails.env}-secrets.yml"
  namespace Rails.env
end
