RspecApiDocumentation.configure do |config|
  config.post_body_formatter = :json
  config.response_body_formatter =
    Proc.new do |_response_content_type, response_body|
      JSON.pretty_generate(JSON.parse(response_body))
    end
end
