describe Onfido::Webhook do
  subject(:webhook) { described_class.new }
  let(:params) do
    {
      "url" => "https://webhookendpoint.url",
      "enabled" => true,
      "events" => [
        "report completion",
        "report withdrawal",
        "check completion",
        "check in progress"
      ]
    }
  end

  describe "#create" do
    it "cretes the webhook" do
      response = webhook.create(params)
      expect(response['id']).to_not be_nil
    end

    it "responds with the right url" do
      response = webhook.create(params)
      expect(response["url"]).to eq params["url"]
    end
  end

  describe "#all" do
    it "returns all the registered webhooks" do
      response = webhook.all
      expect(response["webhooks"].count).to eq 2
    end

    it "returns with id" do
      response = webhook.all
      expect(response["webhooks"][0]["id"]).to_not be_nil
      expect(response["webhooks"][1]["id"]).to_not be_nil
    end
  end
end
