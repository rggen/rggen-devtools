# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.include?(lib) || $LOAD_PATH.unshift(lib)
require 'rggen/devtools/version'

Gem::Specification.new do |spec|
  spec.name = 'rggen-devtools'
  spec.version = RgGen::Devtools::VERSION
  spec.authors = ['Taichi Ishitani']
  spec.email = ['taichi730@gmail.com']

  spec.summary = "rggen-devtools-#{RgGen::Devtools::VERSION}"
  spec.description = 'Development tools for RgGen developers.'
  spec.homepage = 'https://github.com/rggen/rggen-devtools'
  spec.license = 'MIT'

  spec.files = `git ls-files lib LICENSE.txt README.md`.split($RS)
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler'
  spec.add_dependency 'rake'
  spec.add_dependency 'regexp-examples'
  spec.add_dependency 'rspec'
  spec.add_dependency 'rubocop'
  spec.add_dependency 'simplecov'
  spec.add_dependency 'simplecov-cobertura'
end
