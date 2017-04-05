require 'onfido/errors/connection_error'

describe Onfido::Resource do
  subject(:resource) { described_class.new }

  let(:endpoint) { 'https://api.onfido.com/v2/' }
  let(:path)     { 'addresses/pick' }
  let(:url)      { endpoint + path }
  let(:payload)  { { postcode: 'SE1 4NG' } }
  let(:api_key)  { 'some_key' }

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

  before { allow(Onfido).to receive(:endpoint).and_return(endpoint) }
  before { allow(Onfido).to receive(:api_key).and_return(api_key) }

  describe '#url_for' do
    it 'composes the full api url' do
      expect(resource.url_for(path)).to eq(endpoint + path)
    end
  end

  describe '#method_missing' do
    %i(patch).each do |method|
      context "for unsupported HTTP method: #{method}" do
        it 'raises an error' do
          expect do
            resource.public_send(method, url: endpoint)
          end.to raise_error(NoMethodError)
        end
      end
    end
  end

  describe "API key" do
    subject(:resource) { described_class.new(specific_api_key) }

    before do
      expect(RestClient::Request).to receive(:execute).with(
        url: url,
        payload: Rack::Utils.build_query(payload),
        method: :get,
        headers: resource.send(:headers),
        open_timeout: 30,
        timeout: 80
      ).and_call_original

      WebMock.stub_request(:get, url).
        to_return(body: response.to_json, status: 200)
    end

    context "when using a specific key" do
      let(:specific_api_key) { "specific_key" }

      it "uses that key when making the request" do
        resource.get(url: url, payload: payload)

        expect(WebMock).to have_requested(:get, url).with(
          headers: {
            'Authorization' => "Token token=#{specific_api_key}",
            'Accept' => "application/json"
          })
      end
    end

    context "when not using a specific key" do
      let(:specific_api_key) { nil }

      it "uses the general config key when making the request" do
        resource.get(url: url, payload: payload)

        expect(WebMock).to have_requested(:get, url).with(
          headers: {
            'Authorization' => "Token token=#{api_key}",
            'Accept' => "application/json"
          })
      end
    end
  end

  describe "valid http methods" do
    %i(get post put delete).each do |method|
      context "for supported HTTP method: #{method}" do
        context "with a success response" do
          before do
            expect(RestClient::Request).to receive(:execute).
              with(
                url: url,
                payload: Rack::Utils.build_query(payload),
                method: method,
                headers: resource.send(:headers),
                open_timeout: 30,
                timeout: 80
              ).and_call_original

            WebMock.stub_request(method, url).
              to_return(body: response.to_json, status: 200, headers: { "Content-Type" => "application/json" })
          end

          it 'makes a request to an endpoint' do
            expect(resource.public_send(method, url: url, payload: payload)).
              to eq(response)
          end
        end

        context "with a timeout error response" do
          before do
            allow_any_instance_of(RestClient::ExceptionWithResponse).
              to receive(:response).and_return(double(body: "", code: "408"))
            expect(RestClient::Request).to receive(:execute).
              and_raise(RestClient::ExceptionWithResponse)
          end

          it "raises a ConnectionError" do
            expect { resource.public_send(method, url: url, payload: payload) }.
              to raise_error(Onfido::ConnectionError)
          end
        end
      end
    end
  end
end
