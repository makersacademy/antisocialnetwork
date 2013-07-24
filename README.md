README
======

This repository contains the code for a web application built using Ruby version 1.9.3 and Rails 4.

The application uses a PostgreSQL databases. Run `rake db:create:all` to create the databases followed by `rake db:migrate`.

The application needs to be registered as a web application with Facebook, with the url matching the url of this web application.
The application assumes facebook developer credentials are stored in the following environment variables.
  * `ASN_FACEBOOK_ID` - containing the facebook "app code"
  * `ASN_FACEBOOK_SECRET` - containing the facebook "app secret code"

The application assumes that Stripe payment keys are stored in the following environment variables.
  * `STRIPE_PUBLISHABLE_KEY`
  * `STRIPE_SECRET_KEY`

Tests (Specs) can be run with the `rspec` command or `rake spec` (and its derivatives).


* Configuration

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

