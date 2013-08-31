source "https://rubygems.org"

gem "sinatra"
gem "thin"
gem "mongo"
gem "bson_ext"

# Fork v0.13.0.beta2 supporting Ruby 2.0
# Check issue #473
gem "mongo_mapper", :git => "git://github.com/wilhelmbot/mongomapper.git"

gem "haml"
gem 'rack-flash3'

group :development do
  gem 'foreman'
end

group :test do
  gem 'rake'
  gem 'rack-test'
  gem 'capybara'
  gem 'selenium-webdriver'
end
