module Onfido
  class Check < Resource
    def create(applicant_id, payload)
      post(
        url: url_for("applicants/#{applicant_id}/checks"),
        payload: payload
      )
    end

    def find(applicant_id, check_id, expand: nil)
      querystring = "&expand=#{expand}" if expand
      get(url: url_for("applicants/#{applicant_id}/checks/#{check_id}?" \
                       "#{querystring}"))
    end

    def find_by_url(url, expand: nil)
      url_path = url.sub(/^https\:\/\/api\.onfido\.com\/v2\//,'')
      querystring = "&expand=#{expand}" if expand
      get(url: url_for("#{url_path}?#{querystring}")) 
    end

    def all(applicant_id, page: 1, per_page: 20, expand: nil)
      querystring = "page=#{page}&per_page=#{per_page}"
      querystring += "&expand=#{expand}" if expand
      get(url: url_for("applicants/#{applicant_id}/checks?#{querystring}"))
    end

    def resume(check_id)
      post(url: url_for("checks/#{check_id}/resume"))
    end
  end
end
