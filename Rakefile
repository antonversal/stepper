# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "stepper"
  gem.homepage = "http://github.com/antonversal/stepper"
  gem.license = "MIT"
  gem.summary = %Q{Stepper is multistep form (wizard) solution for Rails 3.}
  gem.description = %Q{Stepper is multistep form (wizard) solution for Rails 3. Stepper allows you to split up your large form into series of pages that users can navigate through to complete the form and save it state.}
  gem.email = "ant.ver@gmail.com"
  gem.authors = ["Anton Versal"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

begin
  require 'rcov/rcovtask'
  
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
    test.rcov_opts << '--exclude "gems/*"'
  end
rescue LoadError => e
end

begin
  require "simplecov"
  
  desc "Execute tests with coverage report"
  task :rcov do
    ENV["COVERAGE"]="true"
    Rake::Task["test"].execute
  end
rescue LoadError
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "stepper #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
