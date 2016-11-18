module Onfido
  class Applicant < Resource
    def create(payload)
      post(url: url_for('applicants'), payload: payload)
    end

    def update(applicant_id, payload)
      put(url: url_for("applicants/#{applicant_id}"), payload: payload)
    end

    def destroy(applicant_id)
      delete(url: url_for("applicants/#{applicant_id}"))
    end

    def find(applicant_id)
      get(url: url_for("applicants/#{applicant_id}"))
    end

    def all(page: 1, per_page: 20)
      get(url: url_for("applicants?page=#{page}&per_page=#{per_page}"))
    end
  end
end
