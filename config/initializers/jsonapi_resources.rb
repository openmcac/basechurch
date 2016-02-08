JSONAPI.configure do |config|
  # built in key format options are :underscored_key, :camelized_key and :dasherized_key
  config.json_key_format = :dasherized_key
  config.default_paginator = :paged
end
