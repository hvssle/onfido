module Onfido
  class LiveVideo < Resource
    def find(applicant_id, live_video_id)
      query_string = "applicant_id=#{applicant_id}"
      get(url: url_for("live_videos/#{live_video_id}?#{query_string}"))
    end

    def download(applicant_id, live_video_id)
      query_string = "applicant_id=#{applicant_id}"
      get(url: url_for("live_videos/#{live_video_id}/download?#{query_string}"))
    end

    def all(applicant_id)
      query_string = "applicant_id=#{applicant_id}"
      get(url: url_for("live_videos?#{query_string}"))
    end
  end
end
