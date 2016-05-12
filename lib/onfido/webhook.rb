module Onfido
  class Webhook < Resource
    def create(payload)
      post(
        url: url_for('webhooks'),
        payload: payload
      )
    end

    def find(webhooks_id)
      get(url: url_for("webhooks/#{webhooks_id}"), payload: {})
    end

    def all
      get(
        url: url_for("webhooks"),
        payload: {}
      )
    end
  end
end
