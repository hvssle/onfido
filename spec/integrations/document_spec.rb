require 'tempfile'

describe Onfido::Document do
  subject(:document) { described_class.new }

  describe '#create' do
    after do
      file.close
      file.unlink
    end

    let(:file) { Tempfile.new(['passport', '.jpg']) }
    let(:params) do
      {
        type: 'passport',
        side: 'back',
        file: file
      }
      let(:applicant_id) { '1030303-123123-123123' }

      it 'creates a new document' do
        response = document.create('foobar', params)
        expect(response['id']).not_to be_nil
      end
    end
  end
end
