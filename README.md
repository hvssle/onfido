# Onfido

A wrapper for Onfido's [API](https://onfido.com/documentation#introduction). You should always refer to the documentation for valid API calls.

[![Gem Version](https://badge.fury.io/rb/onfido.svg)](http://badge.fury.io/rb/onfido)
[![Build Status](https://travis-ci.org/hvssle/onfido.svg?branch=master)](https://travis-ci.org/hvssle/onfido)

This gem supports both `v1` and `v2` of the Onfido API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'onfido'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install onfido


## Usage

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

Assuming you have a valid key, you can conveniently make API calls by using an instance of the `API` class.

```ruby
  api = Onfido::API.new
```

### Making calls to Onfido's resources

All resources share the same interface when making API calls. For creating a resource you can use `.create`, for finding one `.find` and for fetching all records for a resource `.all`.

**Note:** *All param keys should be a symbol e.g. `{ type: 'express', reports: [{ name: 'identity' }] }`*


### Applicant

To create an applicant, you can simply use

```ruby
  api.applicant.create(params)
```

To find an existing applicant

```ruby
  api.applicant.find('applicant_id')
```

To get all applicants

```ruby
  api.applicant.all
```

### Document

To upload a document for an applicant, you can simply use

```ruby
  api.document.create('applicant_id', file: 'http://example.com', type: 'passport')
```

The file can both be a `File` object or a link to an image.

### Check

To create a check for an applicant, you can simply use

```ruby
  api.check.create('applicant_id', type: 'express', reports: [{ name: 'identity' }])
```

To find an existing check for an applicant

```ruby
  api.check.find('applicant_id', 'check_id')
```

To get all checks for an applicant

```ruby
  api.check.all('applicant_id')
```

### Report

To find an existing report for a check

```ruby
  api.report.find('check_id', 'report_id')
```

To get all reports for a check

```ruby
  api.report.all('check_id')
```

### Address Picker

To search for addresses by postcode

```ruby
  api.address.all('SE1 4NG')
```

### Pagination

Currently, you can paginate over the *applicant* and *check* resources. However, since you can only create 1 check per applicant therefore paginating on the check resource might prove impractical.

By default, both endpoints are fetching records the first 20 records. That is the maximum amount of records you can request per page.

To paginate over *applicants*:
```ruby
api = Onfido::API.new
api.applicant.all(page: 2, per_page: 10)
```

To paginate over *checks*:
```
api = Onfido::API.new
api.check.all('applicant_id', page: 2, per_page: 10)
```

## Error Handling

There are three classes of errors raised by the library, all of which subclass `Onfido::Error`.
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

### Roadmap

- Improve test coverage with more scenarios
- Add custom errors based on the response code.
- Improve documentation

## Contributing

1. Fork it ( https://github.com/hvssle/onfido/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
