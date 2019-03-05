# frozen_string_literal: true

require 'rake'
require 'rake/tasklib'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

module RgGen
  module Devtools
    module RakeHelper
      extend Rake::DSL

      module_function

      def setup_default_tasks
        RSpec::Core::RakeTask.new(:spec)
        RuboCop::RakeTask.new(:rubocop)
        define_coverage_task(:coverage, :spec)
        task default: :spec
      end

      def define_coverage_task(name, spec_task)
        desc 'Run all RSpec code examples and collect coverage'
        task name do
          ENV['COVERAGE'] = 'yes'
          ENV.key?('CODECOV_TOKEN') && (ENV['USE_CODECOV'] = 'yes')
          Rake::Task[spec_task.to_s].execute
        end
      end
    end
  end
end
