describe Onfido::ReportTypeGroup do
  subject(:report_type_group) { described_class.new }

  describe '#find' do
    let(:id) { '121212-1212-1212' }

    it 'return a retport type group' do
      response = report_type_group.find(id)
      expect(response['id']).not_to be_nil
    end
  end

  describe '#all' do
    it 'return a list of retport type group' do
      response = report_type_group.all
      expect(response['report_type_groups']).not_to be_empty
    end
  end
end
