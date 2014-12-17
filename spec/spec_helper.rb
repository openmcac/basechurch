require 'support/request_helpers'
require "codeclimate-test-reporter"
require "devise"
require 'coveralls'

CodeClimate::TestReporter.start
Coveralls.wear!

RSpec.configure do |config|
  config.include Requests::JsonHelpers, type: :controller
end
