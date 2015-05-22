describe Onfido::Check do
  subject(:check) { described_class.new }
  let(:applicant_id) { '61f659cb-c90b-4067-808a-6136b5c01351' }

  describe '#create' do
    let(:params) do
      {
        type: 'express',
        reports: [{name: 'identity'}]
      }
    end

    it 'creates a new check for an applicant' do
      response = check.create(applicant_id, params)
      expect(response['id']).not_to be_nil
    end
  end

  describe '#find' do
    let(:check_id) { '8546921-123123-123123' }

    it 'returns an existing check for the applicant' do
      response = check.find(applicant_id, check_id)
      expect(response['id']).to eq(check_id)
    end
  end

  describe '#all' do
    let(:check_id) { '8546921-123123-123123' }

    context 'with the default page and per page params' do
      it 'returns all existing checks for the applicant' do
        response = check.all(applicant_id)
        expect(response['checks'].size).to eq(1)
      end
    end
  end
end
