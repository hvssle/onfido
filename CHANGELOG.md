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
