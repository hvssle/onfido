## Unreleased

- BREAKING: remove `throws_exceptions` option. We now always throw exceptions
  for errors. This option had become confusing since `Onfido::ConnectionError`
  was added in v0.0.4, since timeout errors were raised regardless of its value.
- Add base errors class (`Onfido::OnfidoError`)
- Add rubocop, and fix style inconsistencies

## v0.0.4 10 November 2015

- Split out connection errors so they can be automatically retried
