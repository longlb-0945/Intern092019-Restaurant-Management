source "https://rubygems.org"
git_source(:github){|repo| "https://github.com/#{repo}.git"}

ruby "2.6.3"

gem "active_storage_validations", "0.8.2"
gem "bcrypt"
gem "bootsnap", ">= 1.4.2", require: false
gem "bootstrap-sass"
gem "config"
gem "devise"
gem "figaro"
gem "i18n-js"
gem "jbuilder", "~> 2.7"
gem "kaminari"
gem "mysql2", ">= 0.4.4"
gem "puma", "~> 3.11"
gem "rails", "~> 6.0.0"
gem "sass-rails", "~> 5"
gem "turbolinks", "~> 5.2.0"
gem "webpacker", "~> 4.0"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rubocop", "~> 0.74.0", require: false
  gem "rubocop-rails", "~> 2.3.2", require: false
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "ffaker"
  gem "rails-controller-testing"
  gem "rspec-core", git: "https://github.com/rspec/rspec-core"
  gem "rspec-expectations", git: "https://github.com/rspec/rspec-expectations"
  gem "rspec-mocks", git: "https://github.com/rspec/rspec-mocks"
  gem "rspec-rails", git: "https://github.com/rspec/rspec-rails"
  gem "rspec-support", git: "https://github.com/rspec/rspec-support"
  gem "selenium-webdriver"
  gem "shoulda-callback-matchers"
  gem "shoulda-matchers"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
