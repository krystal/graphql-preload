# GraphQL::Preload

Provides a DSL for the [`graphql` gem](https://github.com/rmosolgo/graphql-ruby) that allows ActiveRecord associations to be preloaded in field definitions. Based on a [gist](https://gist.github.com/theorygeek/a1a59a2bf9c59e4b3706ac68d12c8434) by @theorygeek.

This fork works with Ruby on Rails 7.0 and GraphQL-Ruby 1.12 (but not in interpreter mode yet).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'graphql-preload'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install graphql-preload

## Usage

First, enable preloading in your `GraphQL::Schema`:

```ruby
class PreloadSchema < GraphQL::Schema
  use GraphQL::Batch

  enable_preloading

  query QueryType
end
```

Call `preload` when defining your field:

```ruby
class PostType < GraphQL::Schema::Object
  # This runs Post.includes(:comments) but only if comments are requested
  field :comments,  [CommentType], null: false, preload: :comments

  # Block syntax is supported too
  field :comments,  [CommentType], null: false
    preload :comments

    # Post.includes(:comments, :authors)
    preload [:comments, :authors]

    # Post.includes(:comments, authors: [:followers, :posts])
    preload [:comments, { authors: [:followers, :posts] }]
  end
end
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To release a new version of the gem, create a new tag and push it to GitHub.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
