require 'support/request_helpers'

RSpec.configure do |config|
  config.include Requests::JsonHelpers, type: :controller
end
