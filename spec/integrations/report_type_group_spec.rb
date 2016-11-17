describe Onfido::ReportTypeGroup do
  subject(:report_type_group) { described_class.new }

  describe '#find' do
    let(:id) { '8546921-123123-123123' }

    it 'return a retport type group' do
      response = report_type_group.find(id)
      expect(response['id']).not_to be_nil
    end
  end

  describe '#all' do
    it 'return a list of report type group' do
      response = report_type_group.all
      expect(response['report_type_groups']).not_to be_empty
    end
  end
end
