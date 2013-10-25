source 'https://rubygems.org'
ruby '2.0.0'

gem 'sinatra'
gem 'thin'
gem 'mongo'
gem 'bson_ext'

# Fork v0.13.0.beta2 supporting Ruby 2.0 (check issue #473)
gem 'mongo_mapper', '0.13.0.beta2'

gem 'haml'
gem 'rack-flash3'
gem 'i18n'
gem 'mechanize'
gem 'newrelic_rpm'
gem 'rack-protection', '>= 1.5.1'
gem 'rack-attack'

group :development do
  gem 'foreman'
end

group :test do
  gem 'rake'
  gem 'rack-test'
  gem 'rack_session_access'
  gem 'capybara'
  # Fixes http://stackoverflow.com/questions/18555992/bundle-exec-rspec-spec-requests-static-pages-spec-rb-from-hartls-tutorial-isnt
  gem 'rubyzip', '< 1.0.0'
  # Fixes http://stackoverflow.com/questions/18114544/seleniumwebdrivererrorjavascripterror-waiting-for-evaluate-js-load-failed
  gem 'selenium-webdriver', '~> 2.34.0'
end
