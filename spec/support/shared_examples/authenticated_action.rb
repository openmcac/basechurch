# required variables:
#  - perform_action
shared_examples_for 'an authenticated action' do
  before do
    request.headers['Content-Type'] = 'application/vnd.api+json'
    perform_action
  end

  it 'returns a 302 status code' do
    expect(response.status).to eq(302)
  end
end
