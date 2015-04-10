describe Onfido::AddressPicker do
  subject(:api) { Onfido::API.new }

  describe '#list_addresses' do
    it 'returns a list of addresses for postcode' do
      response = api.list_addresses('SE1 4NG')
      expect(response['addresses'].count).to eq(2)
    end
  end
end
