module Onfido
  module AddressPicker
    def list_addresses(postcode)
      get(
        url: url_for('addresses/pick'),
        payload: {postcode: postcode.delete(' ')}
      )
    end
  end
end
