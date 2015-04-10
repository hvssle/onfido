describe Onfido::Address do
  subject(:api) { Onfido::API.new }

  describe '#all' do
    it 'returns the addresses matching the postcode' do
      response = api.address.all('SW1 4NG')
      expect(response['addresses'].count).to eq(2)
    end
  end
end
