describe Onfido::SdkToken do
  subject(:sdk_token) { described_class.new }
  let(:applicant_id) { '61f659cb-c90b-4067-808a-6136b5c01351' }
  let(:referrer) { 'http://*.mywebsite.com/*' }

  describe '#create' do
    let(:params) { { applicant_id: applicant_id, referrer: referrer } }

    it 'creates a new SDK token for the applicant' do
      response = sdk_token.create(params)
      expect(response['token']).not_to be_nil
    end
  end
end
