source 'https://rubygems.org'

# Specify your gem's dependencies in graphql-preload.gemspec
gemspec

gem 'activerecord', ENV['RAILS_VERSION'] && "~> #{ENV['RAILS_VERSION']}.0"

# See https://github.com/nepalez/rspec-sqlimit/issues/13
gem 'rspec-sqlimit', git: 'https://github.com/nepalez/rspec-sqlimit', branch: 'master', ref: '90c85f4143ae584872a6ce1d240d77fa4f3ceb49' # v0.0.3
