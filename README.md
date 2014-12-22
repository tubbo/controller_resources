# ControllerResources

[![Build Status](https://travis-ci.org/tubbo/controller_resources.svg)](https://travis-ci.org/tubbo/controller_resources)
[![Code Climate](https://codeclimate.com/github/tubbo/controller_resources/badges/gpa.svg)](https://codeclimate.com/github/tubbo/controller_resources)
[![Test Coverage](https://codeclimate.com/github/tubbo/controller_resources/badges/coverage.svg)](https://codeclimate.com/github/tubbo/controller_resources)

A Rails engine that unites DecentExposure, StrongParameters, Devise (if
installed) and Draper (if installed) to provide one hell of an awesome
controller DSL.

## Features

- Provides a common DSL for describing strong parameters as well as
  rules for DecentExposure and response types (default: html,json)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'controller_resources'
```

Then run the following generator to generate the locale file:

```bash
$ rails generate controller_resources:install
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

## Contributing

1. Fork it ( https://github.com/tubbo/controller_resources/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
