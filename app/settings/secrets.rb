class Secrets < Settingslogic
  source "#{Basechurch::Engine.root}/config/#{Rails.env}-secrets.yml"
  namespace Rails.env
end
