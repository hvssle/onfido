describe Onfido::API do
  subject(:api) { described_class.new }

  describe 'given a single-word resource' do
    specify { expect(api.address).to be_a(Onfido::Address) }
  end

  describe 'given a multi-word resource' do
    specify { expect(api.live_photo).to be_a(Onfido::LivePhoto) }
  end

  describe 'given an unknown resource' do
    specify { expect { api.blood_test }.to raise_error(NameError) }
  end

  describe 'given no API key' do
    it 'uses nil for the resource API key' do
      expect(Onfido::Address).to receive(:new).with(nil)
      api.address
    end
  end

  describe 'given an API key' do
    let(:api_key) { 'some_key' }

    subject(:api) { described_class.new(api_key: api_key) }

    it 'uses that key to create the resource' do
      expect(Onfido::Address).to receive(:new).with(api_key)
      api.address
    end
  end
end
