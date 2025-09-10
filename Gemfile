source "https://rubygems.org"

gem "rails", "~> 7.2.2", ">= 7.2.2.1"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"
gem "redis", ">= 4.0.1"

# Authentication
gem "devise", "~> 4.9.3"
gem "omniauth", "~> 2.1.1"
gem "omniauth-google-oauth2", "~> 1.2.1"
gem "omniauth-rails_csrf_protection", "~> 1.0.1"

# Authorization
gem "cancancan"

# Admin Panel
gem "activeadmin"

# Asset pipeline & CSS
gem "sprockets-rails"
gem "sassc-rails"
gem "dartsass-rails", "~> 0.4.0"

# File Upload and Image Processing
gem "image_processing", "~> 1.2"
gem "aws-sdk-s3", require: false
gem "active_storage_validations"

# Search and Filter
gem "ransack"
gem "pg_search"

# Pagination
gem "kaminari"

# SEO
gem "meta-tags"
gem "sitemap_generator"

# API Support
gem "rack-cors"

# Payment Simulation and Real Processing
gem "faker"
gem "stripe"

# Performance and Caching
gem "bootsnap", require: false
gem "rack-mini-profiler"
gem "memory_profiler"

# Windows time zone support
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "shoulda-matchers"
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem "database_cleaner-active_record"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  gem "letter_opener"
  gem "annotate"
  gem "bullet"
  gem "error_highlight", ">= 0.4.0", platforms: [ :ruby ]
end

group :test do
end
