module Onfido
  class Webhook < Resource
    def create(payload)
      post(
        url: url_for('webhooks'),
        payload: payload
      )
    end

    def find(webhooks_id)
      get(url: url_for("webhooks/#{webhooks_id}"))
    end

    def all(page: 1, per_page: 20)
      get(url: url_for("webhooks?page=#{page}&per_page=#{per_page}"))
    end
  end
end
