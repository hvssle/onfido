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

    def find(applicant_id, document_id)
      get(url: url_for("applicants/#{applicant_id}/documents/#{document_id}"))
    end

    def download(applicant_id, document_id)
      get(url: url_for("applicants/#{applicant_id}/documents/#{document_id}/download"))
    end

    def all(applicant_id)
      get(url: url_for("applicants/#{applicant_id}/documents"))
    end
  end
end
