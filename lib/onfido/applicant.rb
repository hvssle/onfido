module Onfido
  class Applicant < Resource
    def create(payload)
      post(
        url: url_for('applicants'),
        payload: payload
      )
    end

    def find(applicant_id)
      get(url: url_for("applicants/#{applicant_id}"), payload: {})
    end

    def all
      get(url: url_for("applicants"), payload: {})
    end
  end
end
