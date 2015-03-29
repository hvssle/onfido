describe Onfido::ResponseHandler do
  subject(:handler) { described_class.new(response) }

  describe '#parse!' do
    before do
      allow(Onfido).to receive(:throws_exceptions).and_return(throws_exceptions)
    end

    let(:throws_exceptions) { true }

    context 'when the response is successful' do
      let(:response) { hashified_response.to_json }
      let(:hashified_response) do
        {'success' => 'applicant was successfully created'}
      end

      it 'parses the body and returns it' do
        expect(handler.parse!).to eq(hashified_response)
      end
    end

    context 'when the response has gracefully errored' do
      let(:response) { hashified_response.to_json }
      let(:hashified_response) do
        {
          'error' => {
            'message' => 'Authorization error: please re-check your credentials'
          }
        }
      end

      context 'when throw_exceptions configuration is set to true' do
        it 'raises an error' do
          expect { handler.parse! }.to raise_error(
            Onfido::RequestError,
            'Authorization error: please re-check your credentials'
          )
        end
      end

      context 'when throw_exceptions configuration is set to false' do
        let(:throws_exceptions) { false }


        it 'parses the body and returns it' do
          expect(handler.parse!).to eq(hashified_response)
        end
      end
    end

    context 'when the response is unparseable' do
      let(:response) { 'something : wrong' }

      context 'when throw_exceptions configuration is set to true' do
        it 'raises an error' do
          expect { handler.parse! }.to raise_error(
            Onfido::RequestError,
            'Unparseable response: something : wrong'
          )
        end
      end

      context 'when throw_exceptions configuration is set to false' do
        let(:throws_exceptions) { false }


        it 'parses the body and returns it' do
          expect(handler.parse!).to eq(
            {
              'error' => {
                'message' => 'Unparseable response: something : wrong'
              }
            }
          )
        end
      end
    end
  end
end
