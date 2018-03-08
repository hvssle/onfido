require 'tempfile'

describe Onfido::LivePhoto do
  subject(:live_photo) { described_class.new }

  describe '#create' do
    let(:params) { { file: file } }

    context 'with a File-like object to upload' do
      let(:file) { Tempfile.new(['passport', '.jpg']) }

      after do
        file.close
        file.unlink
      end

      it 'creates a new photo' do
        response = live_photo.create('foobar', params)
        expect(response['id']).not_to be_nil
      end
    end

    context 'passing in a non-File-like file to upload' do
      let(:file) { 'https://onfido.com/images/photo.jpg' }

      it 'raises an ArgumentError' do
        expect { live_photo.create('foobar', params) }.
          to raise_error(ArgumentError, /must be a `File`-like object/)
      end
    end
  end
end
