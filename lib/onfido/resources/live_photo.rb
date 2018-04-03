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

    def find(applicant_id, live_photo_id)
      query_string = "applicant_id=#{applicant_id}"
      get(url: url_for("live_photos/#{live_photo_id}?#{query_string}"))
    end

    def download(applicant_id, live_photo_id)
      query_string = "applicant_id=#{applicant_id}"
      get(url: url_for("live_photos/#{live_photo_id}/download?#{query_string}"))
    end

    def all(applicant_id)
      query_string = "applicant_id=#{applicant_id}"
      get(url: url_for("live_photos?#{query_string}"))
    end
  end
end
