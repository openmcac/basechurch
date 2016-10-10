# required variables:
#  - perform_action
shared_examples_for 'an authenticated action' do
  before do
    request.headers['Content-Type'] = 'application/vnd.api+json'
    perform_action
  end

  it 'returns a 401 status code' do
    expect(response.status).to eq(401)
  end
end

def example_authenticated_request(example_name, request_options = nil, &block)
  before do
    header "Content-Type", "application/vnd.api+json"
  end

  example example_name do
    create(:user).create_new_auth_token.each { |k, v| header k, v }
    do_request(request_options)
    instance_eval(&block)
  end

  example_request "#{example_name} (unauthorized)" do
    expect(status).to eq 401
  end
end

shared_examples_for "an authenticated endpoint" do |example_name|
  example_request "#{example_name} (unauthorized)" do
    expect(status).to eq 401
  end
end
