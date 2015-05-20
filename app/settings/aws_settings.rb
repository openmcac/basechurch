class AwsSettings < Settingslogic
  source "#{Basechurch::Engine.root}/config/aws.yml"
  namespace Rails.env
end

