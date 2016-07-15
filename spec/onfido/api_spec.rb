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
end
