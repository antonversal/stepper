ENV["RAILS_ENV"] = "test"
require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'test/unit'
require 'ruby-debug' unless ENV["CI"]
require 'shoulda'
require 'stepper'
require "rails_app/config/environment"
require "rails/test_help"
require 'capybara/rails'

ActiveRecord::Migrator.migrate(File.expand_path("../rails_app/db/migrate/", __FILE__))
