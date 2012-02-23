# Stepper

[![Build Status](https://secure.travis-ci.org/antonversal/stepper.png)](http://travis-ci.org/antonversal/stepper)

Stepper is multistep form (wizard) solution for Rails 3.1.
Stepper allows you to split up your large form into series of pages that users can navigate through to complete the form and saving it's state.

## Installation

You can use it with Rails 3.1:

`gem install stepper`

## Getting Started

### Configuring model

Create migration for model:

```ruby
  add_column :companies, :current_step, :string
  add_index  :companies, :current_step
```

Setup names of steps that you want to have:

```ruby
  class Company < ActiveRecord::Base
    has_steps :steps => %w{ description kind address }
  end
```

Setup validation for each step if necessary, method should have name like `validate_#{step_name}`:

```ruby
  def validate_description
    self.validates_presence_of :name
    self.validates_presence_of :desc
  end

  def validate_address
    self.validates_presence_of :city
    self.validates_presence_of :country
    self.validates_presence_of :address
  end

  def validate_kind
    self.validates_presence_of :kind
  end
```

Now your model supports a multistep form!

### Configuring controller

Stepper uses `update`, `create`, `new` and `next_step` actions, so you should have the following routes:

```ruby
  resources :companies do
    get :next_step, :on => :member
  end
```

For your controller you need just add the `has_steps method:

```ruby
  class CompaniesController < ApplicationController
    has_steps
  end
```

And you should have a +show+ action because stepper redirects to it after finishing the last step by default. For more options see method documentation.

### Configuring view

Add stepper helper method into the form in view that rendered by new action:

```erb
  <%= form_for(@company) do |f| %>
    <%= stepper f %>
  <% end %>
```

The `stepper` helper renders partial according to the current step of form. Partials should be named like `#{step_name}_step`:

`_name_step.html.erb`

```erb
  <%= f.label :name %>
  <%= f.text_field :name %>
  <%= f.label :desc %>
  <%= f.text_field :desc %>
```

`_city_step.html.erb`

```erb
  <%= f.label :city %>
  <%= f.text_field :city %>
  <%= f.label :country %>
  <%= f.text_field :country %>
  <%= f.label :city %>
  <%= f.text_field :city %>
```

`_kind_step.html.erb`

```erb
  <%= f.label :kind %>
  <%= f.text_field :kind %>
```

`stepper` helper creates buttons "Next", "Previous", "Save" and "Finish" as well. You can change button names by adding the following to your locales:

```ruby
  en:
    stepper:
      next_step: 'Next step'
      previous_step: 'Previous step'
      save: 'Finish later'
      finish: 'Finish'
```

`next_step` button validates, saves current step and renders next step of form;
`previous_step` saves current step and renders previous step of form;
`save` save current step and redirects to index page;
`finish` is showed only for last step instead of `next_step` button and it validates, saves last step and redirects to show.

If you want to have other partials for buttons than add your partial to: `app/views/stepper/_fields.html.erb`

## Contributing to stepper
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Anton Versal. See LICENSE.txt for
further details.

