describe Onfido::Resource do
  let(:resource) { described_class.new }
  let(:url) { Onfido.endpoint + path }
  let(:api_key) { 'some_key' }
  let(:payload) { {postcode: 'SE1 4NG'} }


  before do
    allow(Onfido).to receive(:api_key).and_return(api_key)
  end

  context 'when a response is a 4xx' do
    let(:path) { '4xx_response' }

    context "when 'throws_exceptions' is true" do
      it 'raises a custom error' do
        expect {
          resource.get({url: url, payload: payload})
        }.to raise_error(
        Onfido::RequestError, 'Something went wrong')
      end
    end

    context "when 'throws_exceptions' is false" do
      before do
        allow(Onfido).to receive(:throws_exceptions).and_return(false)
      end

      it 'returns the body as a hash' do
        response = resource.get({url: url, payload: payload})
        expect(response['error']).not_to be_nil
      end
    end
  end
end
