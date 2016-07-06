# ControllerResources

[![Build Status](https://travis-ci.org/tubbo/controller_resources.svg)](https://travis-ci.org/tubbo/controller_resources)
[![Code Climate](https://codeclimate.com/github/tubbo/controller_resources/badges/gpa.svg)](https://codeclimate.com/github/tubbo/controller_resources)
[![Test Coverage](https://codeclimate.com/github/tubbo/controller_resources/badges/coverage.svg)](https://codeclimate.com/github/tubbo/controller_resources)
[![Inline docs](http://inch-ci.org/github/tubbo/controller_resources.svg?branch=master)](http://inch-ci.org/github/tubbo/controller_resources)

A Rails engine providing a common DSL for fetching model resources in
the controller and view layers.

```ruby
class PostsController < ApplicationController
  resource :post
  respond_to :html

  def index
    respond_with @posts
  end
end
```

You can also specify an ancestor, which is used to look up the given
resource.


In this example, `@comment` is being looked up using
`@post.comments.find` rather than the default `Comment.find`.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'controller_resources'
```

And run

```bash
$ bundle install
```

Then, include the module in your base controller class:

```ruby
class ApplicationController < ActionController::Base
  include ControllerResources
end
```

## Usage

Using the `resource` macro, you can define the name of your resource
which will be used to derive instance variable names and class names for
your models. ControllerResources assumes that your instance variables
are named conventionally, and assumes that you follow Rails best
practices when assigning instance variables in the controller.

```ruby
class CommentsController < ApplicationController
  before_action :find_post
  resource :comment, ancestor: :post
  respond_to :html

  def show
    respond_with @comment
  end

  def new
    @comment = @post.comments.build
  end

  def create
    authorize @comment
    @comment = @post.comments.create permitted_params(Comment)
    respond_with @comment
  end

  def update
    authorize @comment
    @comment.update permitted_params(Comment)
    respond_with @comment
  end

  private

  def find_post
    @post = Post.find params[:post_id]
  end
end
```

### Meta-Programming Capabilities

Since `ControllerResources` is programatically defining exposure methods
for you, it also keeps references to the name given in the `resource`
block so you can infer what kind of object you are using in your view.
The `model_name`, `collection_name` and `model` / `collection` methods
are included as helpers along with the rest of the exposure methods in
your view as well as the controller.

For more, consult the [RDoc Documentation][rdoc]

### Customization

As said before, the `model` and `collection` methods are exposed for you
in the controller, and are what is used as the values for the instance
variables set in `:find_resource`. You can override these methods in
your base controller class to perform authorization or decoration logic
in a consistent manner, like so:

```ruby
class ApplicationController < ActionController::Base
  include ControllerResources

  private

  def model
    super.tap do |record|
      authorize record
    end.decorate
  end

  def collection
    super.tap do |records|
      policy_scope records
    end.decorate
  end
end
```

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
