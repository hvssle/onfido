## v0.8.2, 21 April 2017

- Relax [Rack](https://github.com/rack/rack) dependency to allow all versions where `Rack::Utils.secure_compare` is available (@metade)

## v0.8.1, 5 April 2017

- Fix `Content-Type` header handling to be more permissive when detecting JSON (e.g. still recognise the type as JSON when the charset is appended to the header) (@sponomarev)
- Update [`rest-client`](https://github.com/rest-client/rest-client) dependency to 2.x (@timrogers)
- Update [`WebMock`](https://github.com/bblimke/webmock) dependendency to 2.x (@timrogers)

## v0.8.0, 16 November 2016

- Add support for `put` and `delete` http methods to `Onfido::Resource`
- Support no content and binary responses at `Onfido::Resource`
- Add support for `Onfido::ReportTypeGroup` resource
- Add support for update and destroy applicant resource
- Add support for download, find and retrieve all for document resource
- Add support for resume checks
- Add support for resume and cancel report

## v0.7.1, 5 September 2016

- Fix creation of live photos through `Onfido::LivePhoto` resource

## v0.7.0, 8 August 2016

- Add support for dynamic API keys
  (see https://github.com/hvssle/onfido#usage)
- Fix `Onfido::Resource` so it raises `Onfido::ConnectionError` on
  HTTP Error 408 Request Timeout

## v0.6.1, 15 July 2016

- Fix `Onfido::API.live_photo` so it returns an `Onfido::LivePhoto` instance
  (see https://github.com/hvssle/onfido/pull/14)

## v0.6.0, 7 July 2016

- Add `expand` option to `Onfido::Check.find` and `Onfido::Check.all`. See
  https://github.com/hvssle/onfido/pull/11 for details.

## v0.5.0, 7 June 2016

- Add `Onfido::Webhook.valid?` method, for checking the signature of a webhook
  from Onfido

## v0.4.0, 12 May 2016

- BREAKING: target v2 of the Onfido API. To continue using v1, specify this
  version in `Onfido.configure`
- Add `api_version` configuration option
  (see https://github.com/hvssle/onfido#configuration)
- Add support for `Onfido::LivePhoto` resource

## v0.3.0, 16 March 2016

- Add support for `Onfido::Webhook` resource

## v0.2.0, 9 February 2016

- BREAKING: adds `Onfido::ServerError`, which is raised whenever Onfido responds
  with a 5xx code. Previously `Onfido::RequestError` would have been raised, but
  this is now reserved for non-5xx responses.

## v0.1.0, 11 November 2015

- BREAKING: remove `throws_exceptions` option. We now always throw exceptions
  for errors. This option had become confusing since `Onfido::ConnectionError`
  was added in v0.0.4, since timeout errors were raised regardless of its value.
- Add base errors class (`Onfido::OnfidoError`)
- Add rubocop, and fix style inconsistencies

## v0.0.4, 10 November 2015

- Split out connection errors so they can be automatically retried
