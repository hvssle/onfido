module Onfido
  class API
    def initialize(options = {})
      @api_key = options[:api_key]
    end

    def applicant
      Onfido::Applicant.new(@api_key)
    end

    def check
      Onfido::Check.new(@api_key)
    end

    def document
      Onfido::Document.new(@api_key)
    end

    def live_photo
      Onfido::LivePhoto.new(@api_key)
    end

    def live_video
      Onfido::LiveVideo.new(@api_key)
    end

    def report
      Onfido::Report.new(@api_key)
    end

    def report_type_group
      Onfido::ReportTypeGroup.new(@api_key)
    end

    def sdk_token
      Onfido::SdkToken.new(@api_key)
    end

    def webhook
      Onfido::Webhook.new(@api_key)
    end

    def address
      Onfido::Address.new(@api_key)
    end
  end
end
