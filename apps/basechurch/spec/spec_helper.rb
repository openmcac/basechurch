require "codeclimate-test-reporter"
require 'coveralls'

CodeClimate::TestReporter.start
Coveralls.wear!

RSpec.configure do |config|
end
