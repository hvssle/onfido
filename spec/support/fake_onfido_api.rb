require 'sinatra/base'

class FakeOnfidoAPI < Sinatra::Base
  get '/v2/addresses/pick' do
    json_response(200, 'addresses.json')
  end

  post '/v2/applicants' do
    json_response(201, 'applicant.json')
  end

  get '/v2/applicants/:id' do
    json_response(200, 'applicant.json')
  end

  get '/v2/applicants' do
    response = json_response(200, 'applicants.json')
    { applicants: JSON.parse(response)['applicants'][pagination_range] }.to_json
  end

  post '/v2/applicants/:id/documents' do
    json_response(201, 'document.json')
  end

  post '/v2/applicants/:id/live_photos' do
    json_response(201, 'live_photo.json')
  end

  post '/v2/applicants/:id/checks' do
    json_response(201, 'check.json')
  end

  get '/v2/applicants/:id/checks/:id' do
    if params["expand"] == "reports"
      json_response(200, "check_with_expanded_reports.json")
    else
      json_response(200, "check.json")
    end
  end

  get '/v2/applicants/:id/checks' do
    response = if params["expand"] == "reports"
                 json_response(200, "checks_with_expanded_reports.json")
               else
                 json_response(200, "checks.json")
               end

    { checks: JSON.parse(response)['checks'][pagination_range] }.to_json
  end

  get '/v2/checks/:id/reports' do
    json_response(200, 'reports.json')
  end

  get '/v2/checks/:id/reports/:id' do
    json_response(200, 'report.json')
  end

  post '/v2/webhooks' do
    json_response(201, 'webhook.json')
  end

  get '/v2/webhooks/:id' do
    json_response(200, 'webhook.json')
  end

  get '/v2/webhooks' do
    json_response(200, 'webhooks.json')
  end

  get '/v2/4xx_response' do
    json_response(422, '4xx_response.json')
  end

  get '/v2/unexpected_error_format' do
    json_response(400, 'unexpected_error_format.json')
  end

  get '/v2/unparseable_response' do
    content_type :json
    status 504
    ''
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end

  def pagination_range
    start = (params.fetch('page').to_i - 1) * 20
    limit = start + params.fetch('per_page').to_i - 1
    start..limit
  end
end
