# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

helper = File.expand_path('lib/rggen/devtools/gemfile_helper.rb', __dir__)
if File.exist?(helper)
  require helper
  extend RgGen::Devtools::GemfileHelper
  install_rggen
end

group :development_common do
  gem 'bundler', require: false
  gem 'rake', require: false
end

group :development_test do
  gem 'regexp-examples', '~> 1.6.0', require: false
  gem 'rspec', '~> 3.13.0', require: false
  gem 'simplecov', '~> 0.22.0', require: false
  gem 'simplecov-cobertura', '~> 3.0.0', require: false
end

group :development_lint do
  gem 'rubocop', '~> 1.80.1', require: false
end

group :development_local do
  gem 'bump', ' ~> 0.10.0', require: false
  gem 'debug', require: false
  gem 'ruby-lsp', require: false
end
