source "https://rubygems.org"

gem "rails", "~> 8.1.3"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "sidekiq", "~> 8.1"
gem "redis", "~> 5.4"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "activerecord-import"
gem "countries"

group :development, :test do
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "rspec-rails", "~> 8.0"
  gem "rubocop", "~> 1.86"
  gem "rubocop-rails", "~> 2.34"
  gem "rubocop-rspec", "~> 3.9"
  gem "pry", require: false
end
