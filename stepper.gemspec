# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{stepper}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Anton Versal}]
  s.date = %q{2011-10-08}
  s.description = %q{Stepper is multistep form (wizard) solution for Rails 3. Stepper allows you to split up your large form into series of pages that users can navigate through to complete the form and save it state.}
  s.email = %q{ant.ver@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "app/views/stepper/_fields.html.erb",
    "config/locales/stepper.yml",
    "lib/stepper.rb",
    "lib/stepper/controllers/controller_additions.rb",
    "lib/stepper/controllers/controller_resource.rb",
    "lib/stepper/engine.rb",
    "lib/stepper/exceptions.rb",
    "lib/stepper/helper/action_view_additions.rb",
    "lib/stepper/models/active_record_additions.rb",
    "lib/stepper/railtie.rb",
    "stepper.gemspec",
    "test/controllers/controller_additions_test.rb",
    "test/controllers/controller_create_test.rb",
    "test/controllers/controller_invalid_params_test.rb",
    "test/controllers/controller_resource_test.rb",
    "test/controllers/controller_test.rb",
    "test/controllers/controller_update_test.rb",
    "test/controllers/redirect_test.rb",
    "test/helper.rb",
    "test/helpers/helper_test.rb",
    "test/integration/steps_test.rb",
    "test/models/assigns_test.rb",
    "test/models/instance_test.rb",
    "test/models/models_test.rb",
    "test/models/validation_test.rb",
    "test/rails_app/Rakefile",
    "test/rails_app/app/controllers/application_controller.rb",
    "test/rails_app/app/controllers/companies_controller.rb",
    "test/rails_app/app/controllers/orders_controller.rb",
    "test/rails_app/app/helpers/application_helper.rb",
    "test/rails_app/app/mailers/.gitkeep",
    "test/rails_app/app/models/.gitkeep",
    "test/rails_app/app/models/big_company.rb",
    "test/rails_app/app/models/company.rb",
    "test/rails_app/app/models/order.rb",
    "test/rails_app/app/models/users.rb",
    "test/rails_app/app/views/companies/_step1_step.html.erb",
    "test/rails_app/app/views/companies/_step2_step.html.erb",
    "test/rails_app/app/views/companies/_step3_step.html.erb",
    "test/rails_app/app/views/companies/index.html.erb",
    "test/rails_app/app/views/companies/new.html.erb",
    "test/rails_app/app/views/companies/show.html.erb",
    "test/rails_app/app/views/layouts/application.html.erb",
    "test/rails_app/config.ru",
    "test/rails_app/config/application.rb",
    "test/rails_app/config/boot.rb",
    "test/rails_app/config/database.yml",
    "test/rails_app/config/environment.rb",
    "test/rails_app/config/environments/development.rb",
    "test/rails_app/config/environments/production.rb",
    "test/rails_app/config/environments/test.rb",
    "test/rails_app/config/initializers/backtrace_silencers.rb",
    "test/rails_app/config/initializers/inflections.rb",
    "test/rails_app/config/initializers/mime_types.rb",
    "test/rails_app/config/initializers/secret_token.rb",
    "test/rails_app/config/initializers/session_store.rb",
    "test/rails_app/config/initializers/wrap_parameters.rb",
    "test/rails_app/config/locales/en.yml",
    "test/rails_app/config/routes.rb",
    "test/rails_app/db/migrate/20110928102949_create_tables.rb",
    "test/rails_app/db/schema.rb",
    "test/rails_app/lib/assets/.gitkeep",
    "test/rails_app/lib/tasks/.gitkeep",
    "test/rails_app/public/404.html",
    "test/rails_app/public/422.html",
    "test/rails_app/public/500.html",
    "test/rails_app/public/favicon.ico",
    "test/rails_app/public/index.html",
    "test/rails_app/public/robots.txt",
    "test/rails_app/script/rails"
  ]
  s.homepage = %q{http://github.com/antonversal/stepper}
  s.licenses = [%q{MIT}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Stepper is multistep form (wizard) solution for Rails 3.}
  add_dependencies_for_old_rubygems = true

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.1.0"])
      s.add_development_dependency(%q<ruby-debug19>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<jeweler>, [">= 1.6.4"])
      if RUBY_VERSION <= "1.9"
        s.add_development_dependency(%q<rcov>, [">= 0"])
      else
        s.add_development_dependency(%q<simplecov>, [">= 0"])
      end
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<capybara>, [">= 0"])
      s.add_development_dependency(%q<launchy>, [">= 0"])

      add_dependencies_for_old_rubygems = false
    end
  end

  if add_dependencies_for_old_rubygems
    s.add_dependency(%q<rails>, [">= 3.1.0"])
    s.add_dependency(%q<ruby-debug19>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<jeweler>, [">= 1.6.4"])
    if RUBY_VERSION <= "1.9"
      s.add_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<capybara>, [">= 0"])
    s.add_dependency(%q<launchy>, [">= 0"])
  end
end
