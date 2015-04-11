describe Onfido::RequestError do
  subject(:error) do
    described_class.new(failed_response['error']['message']).tap do |e|
      e.type = failed_response['error']['type']
      e.fields = failed_response['error']['fields']
      e.response_code = 401
    end
  end

  let(:failed_response) do
    {
      'error' =>
      {
        'id' => '551722cc964860653c00c202',
        'type' => 'authorization_error',
        'message' => 'Authorization error: please re-check your credentials',
        'fields' => {'name' => {'messages' => ['cannot be blank']} }
      }
    }
  end

  context 'when there is a request error' do
    it 'returns the right message' do
      expect { raise error }.to raise_error('Authorization error: please re-check your credentials')
    end

    it 'has the right error type' do
      expect(error.type).to eq('authorization_error')
    end

    it 'has the right affected fields' do
      expect(error.fields).to eq({'name' => {'messages' => ['cannot be blank']} })
    end

    it 'has the right response code' do
      expect(error.response_code).to eq(401)
    end
  end
end
