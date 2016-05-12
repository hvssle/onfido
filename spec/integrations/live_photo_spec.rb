require 'tempfile'

describe Onfido::LivePhoto do
  subject(:live_photo) { described_class.new }

  describe '#create' do
    after do
      file.close
      file.unlink
    end

    let(:file) { Tempfile.new(['photo', '.jpg']) }
    before { allow(live_photo).to receive(:open).and_return(:file) }
    let(:params) { { file: file } }
    let(:applicant_id) { '1030303-123123-123123' }

    it 'creates a new photo' do
      response = live_photo.create('foobar', params)
      expect(response['id']).not_to be_nil
    end
  end
end
