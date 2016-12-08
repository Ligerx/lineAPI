### Local:
To populate database with mock data: ```rails db:seed```
Or to reset everything: ```rails db:reset```

### Heroku Server:
First reset the database: ```heroku pg:reset DATABASE --confirm queue-api```
Then migrate and seed: ```heroku run rake db:migrate db:seed```

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
