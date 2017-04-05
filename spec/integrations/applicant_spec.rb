describe Onfido::Applicant do
  subject(:applicant) { described_class.new }
  let(:params) do
    {
      'title' => 'Mr',
      'first_name' => 'Chandler',
      'last_name' => 'Bing',
      'gender' => 'male',
      'middle_name' => 'Muriel',
      'dob' => '1968-04-08',
      'telephone' => '555555555',
      'mobile' => '77777777',
      'email' => 'chandler_bing_6@friends.com',
      'addresses' => [
        {
          'flat_number' => '4',
          'building_number' => '100',
          'building_name' => 'Awesome Building',
          'street' => 'Main Street',
          'sub_street' => 'A sub street',
          'town' => 'London',
          'postcode' => 'SW4 6EH',
          'country' => 'GBR'
        },
        {
          'flat_number' => '1',
          'building_number' => '10',
          'building_name' => 'Great Building',
          'street' => 'Old Street',
          'sub_street' => 'Sub Street',
          'town' => 'London',
          'postcode' => 'SW1 4NG',
          'country' => 'GBR'
        }
      ]
    }
  end

  describe '#create' do
    # Need to find a better way of testing that the request is not malformed.
    # Currently this runs for every feature spec. The fact that it's under here
    # is only for semantic reasons

    it 'serializes the payload correctly' do
      WebMock.after_request do |request_signature, _response|
        if request_signature.uri.path == 'v2/applicants'
          expect(Rack::Utils.parse_nested_query(request_signature.body)).
            to eq(params)
        end
      end
    end

    it 'creates an applicant' do
      response = applicant.create(params)
      expect(response['id']).not_to be_nil
    end
  end

  describe '#update' do
    let(:applicant_id) { '61f659cb-c90b-4067-808a-6136b5c01351' }

    it 'updates an applicant' do
      response = applicant.update(applicant_id, params)
      expect(response['id']).to eq(applicant_id)
    end
  end

  describe '#find' do
    let(:applicant_id) { '61f659cb-c90b-4067-808a-6136b5c01351' }

    it 'returns the applicant' do
      response = applicant.find(applicant_id)
      expect(response['id']).to eq(applicant_id)
    end
  end

  describe '#destroy' do
    let(:applicant_id) { '61f659cb-c90b-4067-808a-6136b5c01351' }

    it 'returns success code' do
      expect { applicant.destroy(applicant_id) }.not_to raise_error
    end
  end

  describe '#all' do
    context 'with the default page and per page params' do
      it 'returns all the applicants' do
        response = applicant.all
        expect(response['applicants'].size).to eq(2)
      end
    end

    context 'with specific range of results for a page' do
      it 'returns the specified applicants' do
        response = applicant.all(page: 1, per_page: 1)
        expect(response['applicants'].size).to eq(1)
      end
    end
  end
end
