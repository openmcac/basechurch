require 'support/request_helpers'
require "codeclimate-test-reporter"
require "devise"

CodeClimate::TestReporter.start

RSpec.configure do |config|
  config.include Requests::JsonHelpers, type: :controller
end
