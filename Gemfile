source "http://rubygems.org"
gem "rails", "~> 3.1.0"

group :development, :test do

  unless ENV["CI"]
    gem "ruby-debug19", :require => "ruby-debug", :platforms => [:ruby_19]
    gem "ruby-debug", :platforms => [:ruby_18]
  end

  gem "sqlite3"
  gem "shoulda", ">= 0"
  gem "bundler", "~> 1.0.0"
  gem "jeweler", "~> 1.6.4"
  gem "rcov", ">= 0"
  gem "mocha"
  gem "capybara"
  gem "launchy"
end

