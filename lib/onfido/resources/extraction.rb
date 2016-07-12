module Onfido
  class Extraction < Resource
    def create(payload)
      post(url: url_for('extractions'), payload: payload)
    end

    def find(extraction_id)
      get(url: url_for("extractions/#{extraction_id}"))
    end
  end
end
