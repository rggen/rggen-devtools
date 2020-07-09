# frozen_string_literal: true

require 'regexp-examples'
require_relative 'spec_helper/helper_methods'
require_relative 'spec_helper/matchers'
require_relative 'spec_helper/shared_contexts'

module RgGen
  module Devtools
    module SpecHelper
      module_function

      def apply_default_config(config)
        config.example_status_persistence_file_path = '.rspec_status'
        config.order = :random
        Kernel.srand(config.seed)
      end

      def setup_helpers(config)
        config.include RgGen::Devtools::SpecHelper::HelperMethods
        config.include RgGen::Devtools::SpecHelper::Matchers
      end

      def setup_coverage(filter)
        require 'simplecov'
        SimpleCov.start do
          filter && add_filter(Array(filter))
        end

        ENV.key?('CI') || return

        require 'simplecov-cobertura'
        SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
      end

      def setup(config, coverage_filter: nil)
        setup_helpers(config)
        apply_default_config(config)
        ENV.key?('COVERAGE') && setup_coverage(coverage_filter)
      end
    end
  end
end
