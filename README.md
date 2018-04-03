# Onfido

A thin wrapper for Onfido's API.

[![Gem Version](https://badge.fury.io/rb/onfido.svg)](http://badge.fury.io/rb/onfido)
[![Build Status](https://travis-ci.org/hvssle/onfido.svg?branch=master)](https://travis-ci.org/hvssle/onfido)

This gem supports both `v1` and `v2` of the Onfido API. Refer to Onfido's [API documentation](https://onfido.com/documentation#introduction) for details of the expected requests and responses for both.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'onfido', '~> 0.10.0'
```

The gem is compatible with Ruby 2.2.0 and onwards. Earlier versions of Ruby have [reached end-of-life](https://www.ruby-lang.org/en/news/2017/04/01/support-of-ruby-2-1-has-ended/), are no longer supported and no longer receive security fixes.

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

You can make API calls by using an instance of the `API` class:

```ruby
api = Onfido::API.new
```

Alternatively, you can set an API key here instead of in the initializer:

```ruby
api = Onfido::API.new(api_key: 'API_KEY')
```

### Resources

All resources share the same interface when making API calls. Use `.create` to create a resource, `.find` to find one, and `.all` to fetch all resources.

**Note:** *All param keys should be a symbol e.g. `{ type: 'express', reports: [{ name: 'identity' }] }`*

#### Applicants

Applicants are the object upon which Onfido checks are performed.

```ruby
api.applicant.create(params)                  # => Creates an applicant
api.applicant.update('applicant_id', params)  # => Updates an applicant
api.applicant.destroy('applicant_id')         # => Destroy an applicant
api.applicant.find('applicant_id')            # => Finds a single applicant
api.applicant.all                             # => Returns all applicants
```

#### Documents

Documents provide supporting evidence for Onfido checks.

```ruby
api.document.create('applicant_id', file: 'http://example.com', type: 'passport') # => Creates a document
api.document.find('applicant_id', 'document_id') # => Finds a document
api.document.download('applicant_id', 'document_id') # => Downloads a document as a binary data
api.document.all('applicant_id') # => Returns all applicant's documents
```

**Note:** The file parameter must be a `File`-like object which responds to `#read` and `#path`.
Previous versions of this gem supported providing a URL to a file accessible over HTTP or a path
to a file in the local filesystem. You should instead load the file yourself and then pass it in
to `#create`.

#### Live Photos

Live Photos, like documents, can provide supporting evidence for Onfido checks.

```ruby
api.live_photo.create('applicant_id', file: 'http://example.com')
api.live_photo.find(applicant_id, live_photo_id) # => Finds a live photo
api.live_photo.download(applicant_id, live_photo_id) # => Downloads a live photo as binary data
api.live_photo.all(applicant_id) # => Returns all applicant's live photos
```

**Note:** The file parameter must be a `File`-like object which responds to `#read` and `#path`.
Previous versions of this gem supported providing a URL to a file accessible over HTTP or a path
to a file in the local filesystem. You should instead load the file yourself and then pass it in
to `#create`.

#### Checks

Checks are requests for Onfido to check an applicant, by commissioning one or
more "reports" on them.

```ruby
api.check.create('applicant_id', type: 'express', reports: [{ name: 'identity' }])
api.check.find('applicant_id', 'check_id')
api.check.resume('check_id')
api.check.all('applicant_id')
```

#### Reports

Reports provide details of the results of some part of a "check". They are
created when a check is created, so the Onfido API only provides support for
finding and listing them. For paused reports specifically, additional support for resuming and
 cancelling reports is also available.

```ruby
api.report.find('check_id', 'report_id')
api.report.all('check_id')
api.report.resume('check_id', 'report_id')
api.report.cancel('check_id', 'report_id')
```

#### Report Type Groups

Report type groups provide a convenient way to group and organize different types of reports.
 The Onfido API only provides support for finding and listing them.

```ruby
api.report_type_group.find('report_type_group_id')
api.report_type_group.all()
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

#### SDK Tokens

Onfido allows you to generate JSON Web Tokens via the API in order to authenticate
with Onfido's [JavaScript SDK](https://github.com/onfido/onfido-sdk-ui).

```ruby
api.sdk_token.create(applicant_id: 'applicant_id', referrer: 'referrer')
```

### Pagination

All resources that support an `all` method also support pagination. By default,
the first 20 records are fetched.

### Error Handling

There are three classes of errors raised by the library, all of which subclass `Onfido::OnfidoError`:
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

## Webhooks

Each webhook endpoint has a secret token, generated automatically and [exposed](https://onfido.com/documentation#register-webhook) in the API. When sending a request, Onfido includes a signature computed using the request body and this token in the `X-Signature` header.

This provided signature [should](https://onfido.com/documentation#webhook-security) be compared to one you generate yourself with the token to check that a webhook is a genuine request from Onfido.

```ruby
if Onfido::Webhook.valid?(request.raw_post,
                          request.headers["X-Signature"],
                          ENV['ONFIDO_WEBHOOK_TOKEN'])
  process_webhook
else
  render status: 498, text: "498 Token expired/invalid"
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
