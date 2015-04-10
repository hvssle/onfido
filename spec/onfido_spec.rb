describe Onfido do
  subject(:onfido) { described_class }

  context 'configuration' do
    before do
      onfido.reset
    end

    {api_key: nil, endpoint: 'https://api.onfido.com/v1/', throws_exceptions: true}.each do |config_key, value|
      describe ".#{config_key}" do
        it 'returns the default value' do
          expect(onfido.public_send(config_key)).to eq(value)
        end
      end
    end

    {api_key: 'some_key', throws_exceptions: false}.each do |config_key, new_value|
      describe ".#{config_key}=" do
        it 'changes the configuration to the new value' do
          onfido.public_send("#{config_key}=", new_value)
          expect(onfido.public_send(config_key)).to eq(new_value)
        end
      end
    end

    describe '.logger' do
      context 'when no option is passed' do
        it 'returns the default value' do
          expect(onfido.logger).to be_an_instance_of(Onfido::NullLogger)
        end
      end

      context 'when an option is passed' do
        context 'when the option passed behaves like a logger' do
          let(:logger_like) { double('LoggerLike', :<< => nil) }

          it 'returns the option' do
            onfido.logger = logger_like
            expect(onfido.logger).to eq(logger_like)
          end
        end

        context 'when the option passed does not behave like a logger' do
          let(:non_logger) { double('NotLogger') }

          it 'raises an error' do
            expect {
              onfido.logger = non_logger
            }.to raise_error("#{non_logger.class} doesn't seem to behave like a logger!")
          end
        end
      end
    end
  end
end
