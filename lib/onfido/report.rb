module Onfido
  class Report < Resource
    def find(check_id, report_id)
      get(url: url_for("checks/#{check_id}/reports/#{report_id}"), payload: {})
    end

    def all(check_id)
      get(url: url_for("checks/#{check_id}/reports"), payload: {})
    end
  end
end
