describe Onfido::ConnectionError do
  subject(:error) do
    described_class.new(
      "Invalid response object from API",
      response_code: response_code,
      response_body: response_body
    )
  end

  let(:response_code) { nil }
  let(:response_body) { nil }

  context "without a response_body" do
    its(:json_body) { is_expected.to be_nil }
    its(:type) { is_expected.to be_nil }
    its(:fields) { is_expected.to be_nil }
  end
end
