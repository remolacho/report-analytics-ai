# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version
  `- ruby 3.0.0`


* System dependencies
  - rails 7
  - postgres
  - rspec


* Configuration
  - bundle install
  - change application.example.yml to application.yml
  

* Database creation
  - rake db:create
  - rake db:create RAILS_ENV=test


* Database initialization
  - rake db:migrate
  - rake db:migrate RAILS_ENV=test
  

* How to run the test suite
  - rails rswag:specs:swaggerize (runner the test and create documentation)
  - rails g rspec:swagger namespace::controller_name
  - rspec
  

* Services (job queues, cache servers, search engines, etc.)


* Deployment instructions


* Documentation
  - generate rake rswag:specs:swaggerize
  - http://localhost:3000/api-docs
* ...
