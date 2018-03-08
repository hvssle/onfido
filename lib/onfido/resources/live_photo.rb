module Onfido
  class LivePhoto < Resource
    # with open-uri the file can be a link or an actual file

    def create(applicant_id, payload)
      validate_file!(payload.fetch(:file))
      payload[:applicant_id] = applicant_id

      post(
        url: url_for("/live_photos"),
        payload: payload
      )
    end
  end
end
