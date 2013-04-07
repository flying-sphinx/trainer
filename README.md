= Trainer

Trainer takes a collection of repositories, deploys them each in turn to a Heroku app, running tests via rake tasks each time to confirm they all behave as expected.

More documentation may be forthcoming, but here's the environment variables that need to be set:

* `TRAINER_EMAIL` (email address to send failure notifications to)
* `TRAINER_HEROKU_API_KEY` (Heroku API key for the account that's deploying)
* `TRAINER_HEROKU_APP_NAME` (Heroku app that's being deployed)
* `TRAINER_ORGANISATION` (GitHub organisation that holds all test repositories)
* `TRAINER_PRIVATE_KEY` (private key used for deploying)

You'll also need the Sendgrid add-on (a free account should suffice), and very likely the Scheduler add-on to run the tests regularly.

Tests are run as follows:

    heroku run rake train

Each test repository is expected to respond to the following rake tasks:

* `db:migrate`
* `trainer:prepare`
* `trainer:test`
* `trainer:cleanup`

If `trainer:test` fails (returns a non-zero exit status), an email notification will be sent.

## Contributing

Contributions are very much welcome (albeit unexpected) - but please keep patches in a separate branch, and ideally add tests to cover whatever you're changing.

## Credits

Copyright (c) 2013, Trainer is developed and maintained by [Pat Allan](http://freelancing-gods.com), and is released under the open MIT Licence. It has been built to test various app setups for [Flying Sphinx](http://flying-sphinx.com).
