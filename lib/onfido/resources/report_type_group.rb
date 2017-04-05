module Onfido
  class ReportTypeGroup < Resource
    def find(report_type_group_id)
      get(url: url_for("report_type_groups/#{report_type_group_id}"))
    end

    def all
      get(url: url_for("report_type_groups"))
    end
  end
end
