describe Onfido::Resource do
  subject(:resource) { described_class.new }
  let(:endpoint) { 'https://api.onfido.com/v1/' }
  let(:path) { 'addresses/pick' }
  let(:api_key) { 'some_key' }

  before do
    allow(Onfido).to receive(:endpoint).and_return(endpoint)
    allow(Onfido).to receive(:api_key).and_return(api_key)
  end

  describe '#url_for' do
    it 'composes the full api url' do
      expect(resource.url_for(path)).to eq(endpoint + path)
    end
  end

  describe '#method_missing' do
    %i(put delete patch).each do |method|
      context "for unsupported HTTP method: #{method}" do
        it 'raises an error' do
          expect {
            resource.public_send(method)
          }.to raise_error(NoMethodError)
        end
      end
    end
  end

  describe "valid http methods" do
    %i(get post).each do |method|
      context "for supported HTTP method: #{method}" do
        let(:url) { endpoint + path }
        let(:payload) { {postcode: 'SE1 4NG'} }
        let(:response) do
          {
            'addresses' => [
              {
                'street' => 'Main Street',
                'town' => 'London',
                'postcode' => 'SW4 6EH',
                'country' => 'GBR'
              }
            ]
          }
        end

        before do
          expect(RestClient::Request).to receive(:execute)
            .with(
              url: url,
              payload: Rack::Utils.build_query(payload),
              method: method,
              headers: resource.send(:headers),
              open_timeout: 30,
              timeout: 80
            ).and_call_original

          WebMock.stub_request(method, url).
            to_return(body: response.to_json, status: 200)
        end

        it 'makes a request to an endpoint' do
          expect(resource.public_send(method, {url: url, payload: payload})).
            to eq(response)
        end
      end
    end
  end
end
