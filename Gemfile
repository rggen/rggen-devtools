# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

require File.expand_path('lib/rggen/devtools/gemfile_helper', __dir__)
extend RgGen::Devtools::GemfileHelper

install_rggen

group :development_common do
  gem 'bundler', require: false
  gem 'rake', require: false
end

group :development_test do
  gem 'regexp-examples', '~> 1.6.0', require: false
  gem 'rspec', '~> 3.13.0', require: false
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'simplecov-cobertura', '~> 2.1.0', require: false
end

group :development_lint do
  gem 'rubocop', '~> 1.64.0', require: false
end

group :development_local do
  gem 'bump', ' ~> 0.10.0', require: false
  gem 'debug', require: false
  gem 'ruby-lsp', require: false
end
