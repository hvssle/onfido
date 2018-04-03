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

  describe '#find' do
    let(:applicant_id) { '1030303-123123-123123' }
    let(:live_photo_id) { '3538c8f6-fdce-4745-9d34-fc246bc05aa1' }

    it 'returns the expected live photo' do
      response = live_photo.find(applicant_id, live_photo_id)
      expect(response['id']).to eq(live_photo_id)
    end
  end

  describe '#all' do
    let(:applicant_id) { '1030303-123123-123123' }

    it 'returns list of documents' do
      response = live_photo.all(applicant_id)
      expect(response['live_photos']).not_to be_empty
    end
  end

  describe '#download' do
    let(:applicant_id) { '1030303-123123-123123' }
    let(:live_photo_id) { '3538c8f6-fdce-4745-9d34-fc246bc05aa1' }

    it 'returns the file data' do
      response = live_photo.download(applicant_id, live_photo_id)
      expect(response).not_to be_nil
    end
  end
end
