# frozen_string_literal: true

require 'regexp-examples'
require_relative 'spec_helper/helper_methods'
require_relative 'spec_helper/matchers'
require_relative 'spec_helper/matchers/exit_with_code_matcher'
require_relative 'spec_helper/matchers/have_property_matcher'
require_relative 'spec_helper/matchers/have_value_matcher'
require_relative 'spec_helper/matchers/match_string_matcher'
require_relative 'spec_helper/matchers/match_value_matcher'

module RgGen
  module Devtools
    module SpecHelper
      module_function

      def apply_default_config(config)
        config.example_status_persistence_file_path = '.rspec_status'
        config.expect_with(:rspec) do |expectations|
          expectations.syntax = :expect
        end
        config.mock_with(:rspec) do |mocks|
          mocks.syntax = :expect
        end
      end

      def setup_helpers(config)
        config.include RgGen::Devtools::SpecHelper::HelperMethods
        config.include RgGen::Devtools::SpecHelper::Matchers
      end

      def setup_coverage(use_codecov, filters)
        require 'simplecov'
        SimpleCov.start do
          Array(filters).each { |filter| add_filter(filter) }
        end

        return unless use_codecov

        require 'codecov'
        SimpleCov.formatter = SimpleCov::Formatter::Codecov
      end

      def setup(config, filters = nil)
        apply_default_config(config)
        setup_helpers(config)
        ENV.key?('COVERAGE') &&
          setup_coverage(ENV.key?('USE_CODECOV'), filters)
      end
    end
  end
end
