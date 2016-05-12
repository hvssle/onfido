# Onfido

A thin wrapper for Onfido's API.

[![Gem Version](https://badge.fury.io/rb/onfido.svg)](http://badge.fury.io/rb/onfido)
[![Build Status](https://travis-ci.org/hvssle/onfido.svg?branch=master)](https://travis-ci.org/hvssle/onfido)

This gem supports both `v1` and `v2` of the Onfido API. Refer to Onfido's [API documentation](https://onfido.com/documentation#introduction) for details of the expected requests and responses for both.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'onfido'
```

## Configuration

There are 5 configuration options:

```ruby
Onfido.configure do |config|
  config.api_key = 'MY_API_KEY'
  config.api_version = 'v2'
  config.logger = Logger.new(STDOUT)
  config.open_timeout = 30
  config.read_timeout = 80
end
```

## Usage

Assuming you have a valid key, you can conveniently make API calls by using an instance of the `API` class.

```ruby
api = Onfido::API.new
```

All resources share the same interface when making API calls. Use `.create` to create a resource, `.find` to find one, and `.all` to fetch all resources.

**Note:** *All param keys should be a symbol e.g. `{ type: 'express', reports: [{ name: 'identity' }] }`*

### Resources

#### Applicants

Applicants are the object upon which Onfido checks are performed.

```ruby
api.applicant.create(params)          # => Creates an applicant
api.applicant.find('applicant_id')    # => Finds a single applicant
api.applicant.all                     # => Returns all applicants
```

#### Documents

Documents provide supporting evidence for Onfido checks. They can only be
created - the Onfido does not support finding or listing them.

```ruby
api.document.create('applicant_id', file: 'http://example.com', type: 'passport')
```

**Note:** The file parameter can be either a `File` object or a link to an image.

#### Live Photos

Live Photos, like documents, can provide supporting evidence for Onfido checks.
They can only be created - the Onfido does not support finding or listing them.

```ruby
api.live_photo.create('applicant_id', file: 'http://example.com')
```

**Note:** The file parameter can be either a `File` object or a link to an image.

#### Checks

Checks are requests for Onfido to check an applicant, by commissioning one or
more "reports" on them.

```ruby
api.check.create('applicant_id', type: 'express', reports: [{ name: 'identity' }])
api.check.find('applicant_id', 'check_id')
api.check.all('applicant_id')
```

#### Reports

Reports provide details of the results of some part of a "check". They are
created when a check is created, so the Onfido API only provides support for
finding and listing them.

```ruby
api.report.find('check_id', 'report_id')
api.report.all('check_id')
```

#### Address Lookups

Onfido provides an address lookup service, to help ensure well-formatted
addresses are provided when creating "applicants". To search for addresses
by postcode, use:

```ruby
api.address.all('SE1 4NG')
```

#### Webhook Endpoints

Onfido allows you to set up and view your webhook endpoints via the API, as well
as through the dashboard.

```ruby
api.webhook.create(params)          # => Creates a webhook endpoint
api.webhook.find('webhook_id')      # => Finds a single webhook endpoint
api.webhook.all                     # => Returns all webhook endpoints
```

### Pagination

All resources that support an `all` method also support pagination. By default,
the first 20 records are fetched.

### Error Handling

There are three classes of errors raised by the library, all of which subclass `Onfido::Error`:
- `Onfido::ServerError` is raised whenever Onfido returns a `5xx` response
- `Onfido::RequestError` is raised whenever Onfido returns any other kind of error
- `Onfido::ConnectionError` is raised whenever a network error occurs (e.g., a timeout)

All three error classes provide the `response_code`, `response_body`, `json_body`, `type` and `fields` of the error (although for `Onfido::ServerError` and `Onfido::ConnectionError` the last three are likely to be `nil`).

```ruby
def create_applicant
  api.applicant.create(params)
rescue Onfido::RequestError => e
  e.type          # => 'validation_error'
  e.fields        # => { "email": { "messages": ["invalid format"] } }
  e.response_code # => '422'
end
```

## Roadmap

- Improve test coverage with more scenarios
- Add custom errors based on the response code
- Improve pagination handling (use information passed in link header)

## Contributing

1. Fork it ( https://github.com/hvssle/onfido/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
