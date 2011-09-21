require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'active_record'
require 'active_record/fixtures'
require 'test/unit'
require 'shoulda'
require 'stepper'
require 'ruby-debug'

FIXTURES_PATH = File.join(File.dirname(__FILE__), 'fixtures')

ActiveRecord::Base.establish_connection(
  :adapter  => 'sqlite3',
  :database => ':memory:'
)

dep = defined?(ActiveSupport::Dependencies) ? ActiveSupport::Dependencies : ::Dependencies
dep.autoload_paths.unshift FIXTURES_PATH

ActiveRecord::Base.silence do
  ActiveRecord::Migration.verbose = false
  load File.join(FIXTURES_PATH, 'schema.rb')
end

I18n.load_path << File.join(File.dirname(__FILE__), 'locales', 'en.yml')
I18n.reload!

#ActiveRecord::Fixtures.create_fixtures(FIXTURES_PATH, ActiveRecord::Base.connection.tables)

ActionController::Base.view_paths = File.join(File.dirname(__FILE__), 'views')

Stepper::Routes = ActionDispatch::Routing::RouteSet.new
Stepper::Routes.draw do
  resources 'companies' do
    get :next_step, :on => :member
  end
  root :to => 'countries#index'
end

ActionController::Base.send :include, Stepper::Routes.url_helpers

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))


class Test::Unit::TestCase
end

class ActiveSupport::TestCase
  setup do
    @routes = Stepper::Routes
  end
end