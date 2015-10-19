# ControllerResources

[![Build Status](https://travis-ci.org/tubbo/controller_resources.svg)](https://travis-ci.org/tubbo/controller_resources)
[![Code Climate](https://codeclimate.com/github/tubbo/controller_resources/badges/gpa.svg)](https://codeclimate.com/github/tubbo/controller_resources)
[![Test Coverage](https://codeclimate.com/github/tubbo/controller_resources/badges/coverage.svg)](https://codeclimate.com/github/tubbo/controller_resources)
[![Inline docs](http://inch-ci.org/github/tubbo/controller_resources.svg?branch=master)](http://inch-ci.org/github/tubbo/controller_resources)

A Rails engine providing a common DSL for fetching model resources in
the controller and view layers. It leverages
[DecentExposure][de], [StrongParameters][sp] and assumes an
ActiveRecord-like DSL for querying model objects.
ControllerResources does not assume any part of your stack, instead
providing generic tools and extensions to ActionController which allow
you to use the fetched resources however you want.

```ruby
resource :post do
  permit :title, :category, :body, :is_published
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
resource :comment, ancestor: :post do
  permit :body, :user_id
end
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'controller_resources'
```

And run

```bash
$ bundle install
```

## Usage

Define your resource in the controller, and you can use methods instead
of instance variables to access the model object. No more writing finder
methods!

```ruby
class ItemsController < ApplicationController
  resource :item do
    permit :name, :user, :is_private
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

### Meta-Programming Capabilities

Since `ControllerResources` is programatically defining exposure methods
for you, it also keeps references to the name given in the `resource`
block so you can infer what kind of object you are using in your view.
The `model_name`, `collection_name` and `model` / `collection` methods
are included as helpers along with the rest of the exposure methods in
your view as well as the controller.

For more, consult the [RDoc Documentation][rdoc]

## Contributing

Contributions to `ControllerResources` may be made using GitHub pull
requests. You must include accompanying tests, and all tests must pass
for any contribution to be considered.

**NOTE:** Running tests requires that you have [PhantomJS][pjs]
installed.

To run tests:

```bash
$ bin/rake test
```

This will also use Rubocop to lint-check your code so it adheres to our
style guide.

## Releasing

All acceptance testing and final RubyGems.org releasing is performed
automatically by [Travis CI][ci]. When a new gem version needs to be
released, one with push access to the repo can update the version by
running the following Rake task, which will tag the latest version of
the gem and push all commits to GitHub, where it will be picked up by
Travis and auto-deployed to [RubyGems][rg]:

```bash
$ bin/rake release
```

## Compatibility

ControllerResources adheres to the [Semantic Versioning][sv]
standard for publishing new versions of the library. Bug fixes will be
pushed in patch updates, while new features that maintain compatibility
will be available in minor updates. Major updates are reserved for new
features that break existing compatibility.

### Ruby version support

This project will be tested against any version of MRI that is currently
being supported by the Ruby core team. It is not currently being tested
on JRuby or Rubinius. For more information on what versions of Ruby
we're testing, see [Travis CI][ci].

[de]: https://github.com/hashrocket/decent_exposure
[sp]: https://github.com/rails/strong_parameters
[ci]: https://travis-ci.org
[rg]: https://rubygems.org
[pjs]: http://phantomjs.org
[sv]: http://semver.org
[rdoc]: http://rubydoc.info/github/tubbo/controller_resources/master
