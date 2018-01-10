module Onfido
  class SdkToken < Resource
    def create(payload)
      post(
        url: url_for("sdk_token"),
        payload: payload
      )
    end
  end
end
