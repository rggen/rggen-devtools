# frozen_string_literal: true

require File.expand_path('lib/rggen/devtools/version', __dir__)

Gem::Specification.new do |spec|
  spec.name = 'rggen-devtools'
  spec.version = RgGen::Devtools::VERSION
  spec.authors = ['Taichi Ishitani']
  spec.email = ['rggen@googlegroups.com']

  spec.summary = "rggen-devtools-#{RgGen::Devtools::VERSION}"
  spec.description = 'Development tools for RgGen developers.'
  spec.homepage = 'https://github.com/rggen/rggen-devtools'
  spec.license = 'MIT'

  spec.files = `git ls-files lib LICENSE.txt`.split($RS)
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler'
end
