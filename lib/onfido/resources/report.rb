module Onfido
  class Report < Resource
    def find(check_id, report_id)
      get(url: url_for("checks/#{check_id}/reports/#{report_id}"))
    end

    def all(check_id, page: 1, per_page: 20)
      querystring = "page=#{page}&per_page=#{per_page}"
      get(url: url_for("checks/#{check_id}/reports?#{querystring}"))
    end

    def resume(check_id, report_id)
      post(url: url_for("checks/#{check_id}/reports/#{report_id}/resume"))
    end

    def cancel(check_id, report_id)
      post(url: url_for("checks/#{check_id}/reports/#{report_id}/cancel"))
    end
  end
end
