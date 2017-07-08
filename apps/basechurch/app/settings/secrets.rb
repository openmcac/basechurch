class Secrets < Settingslogic
  if ["staging", "production"].include?(Rails.env)
    source "#{Rails.root}/config/secrets.yml"
  else
    source "#{Rails.root}/config/#{Rails.env}-secrets.yml"
  end

  namespace Rails.env
end
