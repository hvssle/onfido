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
