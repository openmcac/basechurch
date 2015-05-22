class AwsSettings < Settingslogic
  source "#{Rails.root}/config/aws.yml"
  namespace Rails.env
end
