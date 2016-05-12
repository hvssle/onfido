module Onfido
  class Applicant < Resource
    def create(payload)
      post(url: url_for('applicants'), payload: payload)
    end

    def find(applicant_id)
      get(url: url_for("applicants/#{applicant_id}"))
    end

    def all(page: 1, per_page: 20)
      get(url: url_for("applicants?page=#{page}&per_page=#{per_page}"))
    end
  end
end
