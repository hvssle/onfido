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
  end
end
