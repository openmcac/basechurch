RspecApiDocumentation.configure do |config|
  config.response_body_formatter = Proc.new do |response_content_type, response_body|
    JSON.pretty_generate(JSON.parse(response_body))
  end
end
