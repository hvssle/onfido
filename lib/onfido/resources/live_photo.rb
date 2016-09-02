module Onfido
  class LivePhoto < Resource
    # with open-uri the file can be a link or an actual file

    def create(applicant_id, payload)
      payload[:applicant_id] = applicant_id
      payload[:file] = open(payload.fetch(:file), 'r')
      post(
        url: url_for("/live_photos"),
        payload: payload
      )
    end
  end
end
