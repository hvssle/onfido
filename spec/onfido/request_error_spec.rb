describe Onfido::RequestError do
  subject(:error) do
    described_class.new(
      failed_response['error']['message'],
      response_code: 401,
      response_body: failed_response.to_json
    )
  end

  let(:failed_response) do
    {
      'error' =>
      {
        'id' => '551722cc964860653c00c202',
        'type' => 'authorization_error',
        'message' => 'Authorization error: please re-check your credentials',
        'fields' => { 'name' => { 'messages' => ['cannot be blank'] } }
      }
    }
  end

  it 'returns the right message' do
    expect { raise error }.
      to raise_error('Authorization error: please re-check your credentials')
  end

  its(:type) { is_expected.to eq('authorization_error') }
  its(:response_code) { is_expected.to eq(401) }
  its(:response_body) { is_expected.to eq(failed_response.to_json) }
  its(:json_body) { is_expected.to eq(failed_response) }
  its(:fields) do
    is_expected.to eq('name' => { 'messages' => ['cannot be blank'] })
  end
end
