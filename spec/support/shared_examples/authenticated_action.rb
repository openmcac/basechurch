# required variables:
#  - perform_action
shared_examples_for 'an authenticated action' do
  before { perform_action }

  it 'returns a 302 status code' do
    expect(response.status).to eq(302)
  end
end
