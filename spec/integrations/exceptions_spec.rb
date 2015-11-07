describe Onfido::Resource do
  let(:resource) { described_class.new }
  let(:url) { Onfido.endpoint + path }
  let(:api_key) { 'some_key' }
  let(:payload) { { postcode: 'SE1 4NG' } }


  before do
    allow(Onfido).to receive(:api_key).and_return(api_key)
  end

  context '4xx response' do
    let(:path) { '4xx_response' }

    context "when 'throws_exceptions' is true" do
      before { allow(Onfido).to receive(:throws_exceptions).and_return(true) }

      it 'raises a custom error' do
        expect { resource.get({ url: url, payload: payload }) }.
          to raise_error(Onfido::RequestError, 'Something went wrong')
      end
    end

    context "when 'throws_exceptions' is false" do
      before { allow(Onfido).to receive(:throws_exceptions).and_return(false) }

      it 'returns the body as a hash' do
        response = resource.get({ url: url, payload: payload })
        expect(response['error']).not_to be_nil
      end
    end
  end

  context 'unexpected error format' do
    let(:path) { 'unexpected_error_format' }

    context "when 'throws_exceptions' is true" do
      before { allow(Onfido).to receive(:throws_exceptions).and_return(true) }

      it 'raises a custom error' do
        expect { resource.get({ url: url, payload: payload }) }.
          to raise_error(Onfido::RequestError, /response code was 400/)
      end
    end

    context "when 'throws_exceptions' is false" do
      before { allow(Onfido).to receive(:throws_exceptions).and_return(false) }

      it 'still raises a custom error' do
        expect { resource.get({ url: url, payload: payload }) }.
          to raise_error(Onfido::RequestError, /response code was 400/)
      end
    end
  end

  context 'unparseable JSON' do
    let(:path) { 'unparseable_response' }

    context "when 'throws_exceptions' is true" do
      before { allow(Onfido).to receive(:throws_exceptions).and_return(true) }

      it 'raises a custom error' do
        expect { resource.get({ url: url, payload: payload }) }.
          to raise_error(Onfido::RequestError, /response code was 504/)
      end
    end

    context "when 'throws_exceptions' is false" do
      before { allow(Onfido).to receive(:throws_exceptions).and_return(false) }

      it 'still raises a custom error' do
        expect { resource.get({ url: url, payload: payload }) }.
          to raise_error(Onfido::RequestError, /response code was 504/)
      end
    end
  end

  context 'timeout' do
    before do
      allow(RestClient::Request).
        to receive(:execute).
        and_raise(RestClient::RequestTimeout)
    end

    it 'raises a ConnectionError' do
      expect { resource.get({ url: Onfido.endpoint, payload: payload }) }.
        to raise_error(Onfido::ConnectionError, /Could not connect/)
    end
  end

  context 'broken connection' do
    before do
      allow(RestClient::Request).
        to receive(:execute).
        and_raise(RestClient::ServerBrokeConnection)
    end

    it 'raises a ConnectionError' do
      expect { resource.get({ url: Onfido.endpoint, payload: payload }) }.
        to raise_error(Onfido::ConnectionError, /connection to the server/)
    end
  end

  context "bad SSL certificate" do
    before do
      allow(RestClient::Request).
        to receive(:execute).
        and_raise(RestClient::SSLCertificateNotVerified.new(nil))
    end

    it 'raises a ConnectionError' do
      expect { resource.get({ url: Onfido.endpoint, payload: payload }) }.
        to raise_error(Onfido::ConnectionError, /SSL certificate/)
    end
  end
end
