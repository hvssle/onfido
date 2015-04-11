module Onfido
  class Check < Resource
    def create(applicant_id, payload)
      post(
         url: url_for("applicants/#{applicant_id}/checks"),
         payload: payload
      )
    end

    def find(applicant_id, check_id)
      get(
        url: url_for("applicants/#{applicant_id}/checks/#{check_id}"),
        payload: {}
      )
    end

    def all(applicant_id)
      get(url: url_for("applicants/#{applicant_id}/checks"), payload: {})
    end
  end
end
