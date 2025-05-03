source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.3", ">= 7.0.3.1"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# OpenAI integration
gem "ruby-openai", "~> 5.2"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Build JSON APIs with ease
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"

# Polar y procesamiento de datos
gem "polars-df"
gem 'parallel'            # Para procesamiento paralelo
gem 'roo', '~> 2.10.0'   # Para manejo de archivos Excel

# Gemas existentes útiles
gem 'multi_json', '~> 1.11', '>= 1.11.2'
gem 'rswag'
gem 'annotate', '~> 3.2.0'
gem 'figaro', '~> 1.2.0'
gem 'auth_jwt_go', '~> 1.0.3'
gem 'jwt', '~> 2.4.1'
gem 'rack-cors', '~> 1.1.1'
gem 'rest-client', '~> 2.1.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'pry', '~> 0.14.2'
  gem 'factory_bot_rails', '~> 6.2.0'
  gem 'faker', '~> 2.21.0'
  gem 'rspec-rails', '~> 4.1.2'
  gem 'pry-byebug', '~> 3.10.0'
end

group :test do
  gem 'database_cleaner', '~> 2.0.1'
end
