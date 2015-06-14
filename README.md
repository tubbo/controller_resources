# ControllerResources

[![Build Status](https://travis-ci.org/tubbo/controller_resources.svg)](https://travis-ci.org/tubbo/controller_resources)
[![Code Climate](https://codeclimate.com/github/tubbo/controller_resources/badges/gpa.svg)](https://codeclimate.com/github/tubbo/controller_resources)
[![Test Coverage](https://codeclimate.com/github/tubbo/controller_resources/badges/coverage.svg)](https://codeclimate.com/github/tubbo/controller_resources)

A controller DSL for Rails that allows you to easily and quickly define
both singular and collection model resources that can be operated on
within the controller. Attempts to DRY up most of the boilerplate code
at the top of each controller used to set up its state.

ControllerResources leverages [DecentExposure][de], [Responders][rp] and
[StrongParameters][sp] to do most of its heavy lifting. DecentExposure
is used to populate the resource attributes of the controller, so you
can have access to the singular and plural names of the resource as
methods in each controller action, populated with what you would expect
as DecentExposure likes to do. Now, all you have to do in order to
establish all the data you'll need for your controller is:

```ruby
resource :post do
  search :title, :category
  modify :title, :category, :body, :is_published
end
```

...and not have to worry about where the `posts` and `post` methods come
from. If you're used to working with DecentExposure, you'll know that
we're just using the `expose` macro to set up these resources, and using
the `resource` macro to populate what we expose and additionally what
parameters to pass through.

You can establish DecentExposure configuration with the `resource` block
by calling methods which do not exist on the Resource. All of these
methods are passed down to DecentExposure:

```ruby
expose :post, param: :post_id
resource :comment do
  ancestor :post
  search :body
  modify :body, :user_id
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'controller_resources'
```

Then run the following generator to generate the locale files for
Responders:

```bash
$ rails generate responders:install
```

This will also insert Responders into your `ApplicationController`. If
you do not want this, be sure to include the following code in a base
controller somewhere...this is the best way for `ControllerResources` to
function:

```ruby
class ApplicationController < ActionController::Base
  responders :flash, :http_cache
end
```

## Usage

Define your resource in the controller, and you can use methods instead
of instance variables to access the model object. No more writing finder
methods!

```ruby
class ItemsController < ApplicationController
  resource :item do
    search :name, :user
    modify :name, :user, :is_private
  end

  def index
    respond_with items
  end

  def show
    respond_with item
  end

  def create
    item.save
    respond_with item
  end
end
```

In your view, you can use methods instead of instance variables to
access the model objects passed down into the template:

```erb
<%= user.name %>
```

You can also use some given helpers for establishing authorization logic
in ApplicationController. Since `ControllerResources` is included by
default, you can use the given `current_resource` method to tell Pundit
(for example) which policy to use in authorization:

```ruby
class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :authorize_user!

  rescue_from Pundit::NotAuthorizedError, with: :forbidden

  def forbidden
    render 'forbidden', status: :forbidden
  end

  private

  def authorize_user!
    authorize current_user, current_resource, current_action
  end

  def current_action
    :"#{action_name}?"
  end
end
```

This `current_resource` method is populated by the given configured
Resource object, which will attempt to classify its `model_name` and
provide a class constant that can be used here. In the
`PostsController#show` action, for example, that call to `authorize` would be
partially expanded like this:

```ruby
authorize current_user, Post, :show?
```

(where `current_user` is the authenticated User found by Devise)

While ControllerResources doesn't provide authorization or
authentication helpers, it does provide the necessary methods to aid
your own authorization and authentication frameworks in their job.

## Contributing

Contributions to `ControllerResources` may be made using GitHub pull
requests. You must include accompanying tests, and all tests must pass
for any contribution to be considered.

To run tests:

```bash
$ rake test
```

This will also use Rubocop to lint-check your code so it adheres to our
style guide.

[de]: https://github.com/hashrocket/decent_exposure
[rp]: https://github.com/plataformatec/responders
[sp]: https://github.com/rails/strong_parameters

