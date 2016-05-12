module Onfido
  class Address < Resource
    def all(postcode)
      get(
        url: url_for('addresses/pick'),
        payload: { postcode: postcode.delete(' ') }
      )
    end
  end
end
