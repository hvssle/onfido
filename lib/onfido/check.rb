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

    def all(applicant_id, page: 1, per_page: 20)
      get(
        url: url_for("applicants/#{applicant_id}/checks?page=#{page}&per_page=#{per_page}"),
        payload: {}
      )
    end
  end
end
