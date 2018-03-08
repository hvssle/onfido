require 'tempfile'

describe Onfido::Document do
  subject(:document) { described_class.new }

  describe '#create' do
    let(:params) do
      {
        type: 'passport',
        side: 'back',
        file: file
      }
    end
    let(:applicant_id) { '1030303-123123-123123' }

    context 'with a File-like object to upload' do
      let(:file) { Tempfile.new(['passport', '.jpg']) }

      after do
        file.close
        file.unlink
      end

      it 'creates a new document' do
        response = document.create('foobar', params)
        expect(response['id']).not_to be_nil
      end
    end

    context 'passing in a non-File-like file to upload' do
      let(:file) { 'https://onfido.com/images/logo.png' }

      it 'raises an ArgumentError' do
        expect { document.create('foobar', params) }.
          to raise_error(ArgumentError, /must be a `File`-like object/)
      end
    end
  end

  describe '#find' do
    let(:applicant_id) { '1030303-123123-123123' }
    let(:document_id) { '7568415-123123-123123' }

    it 'returns the expected document' do
      response = document.find(applicant_id, document_id)
      expect(response['id']).to eq(document_id)
    end
  end

  describe '#all' do
    let(:applicant_id) { '1030303-123123-123123' }

    it 'returns list of documents' do
      response = document.all(applicant_id)
      expect(response['documents']).not_to be_empty
    end
  end

  describe '#download' do
    let(:applicant_id) { '1030303-123123-123123' }
    let(:document_id) { '1212121-123123-123123' }

    it 'returns the file data' do
      response = document.download(applicant_id, document_id)
      expect(response).not_to be_nil
    end
  end
end
