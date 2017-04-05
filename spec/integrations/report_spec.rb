describe Onfido::Report do
  subject(:report) { described_class.new }
  let(:check_id) { '8546921-123123-123123' }

  describe '#find' do
    let(:report_id) { '6951786-123123-422221' }

    it 'returns a report for an existing check' do
      response = report.find(check_id, report_id)
      expect(response['id']).to eq(report_id)
    end
  end

  describe '#all' do
    it 'lists all reports for an existing check' do
      response = report.all(check_id)
      expect(response['reports'].count).to eq(2)
    end
  end

  describe '#resume' do
    let(:report_id) { '6951786-123123-422221' }
    let(:check_id) { '1212121-123123-422221' }

    it 'returns a success response' do
      expect { report.resume(check_id, report_id) }.not_to raise_error
    end
  end

  describe '#cancel' do
    let(:report_id) { '6951786-123123-422221' }
    let(:check_id) { '1212121-123123-422221' }

    it 'returns a success response' do
      expect { report.cancel(check_id, report_id) }.not_to raise_error
    end
  end
end
