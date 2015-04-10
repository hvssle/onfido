module Onfido
  class Document < Resource
    # with open-uri the file can be a link or an actual file

    def create(applicant_id, payload)
      payload[:file] = open(payload.fetch(:file), 'r')
      post(
        url: url_for("applicants/#{applicant_id}/documents"),
        payload: payload
      )
    end
  end
end
