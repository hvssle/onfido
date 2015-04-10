require 'sinatra/base'

class FakeOnfidoAPI < Sinatra::Base
  get '/v1/addresses/pick' do
    json_response 200, 'address_picker.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
