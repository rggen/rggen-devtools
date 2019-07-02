# frozen_string_literal: true

require 'regexp-examples'
require_relative 'spec_helper/helper_methods'
require_relative 'spec_helper/matchers'
require_relative 'spec_helper/matchers/exit_with_code_matcher'
require_relative 'spec_helper/matchers/generate_code_matcher'
require_relative 'spec_helper/matchers/have_declaration_matcher'
require_relative 'spec_helper/matchers/have_identifier_matcher'
require_relative 'spec_helper/matchers/have_property_matcher'
require_relative 'spec_helper/matchers/have_value_matcher'
require_relative 'spec_helper/matchers/match_declaration_matcher'
require_relative 'spec_helper/matchers/match_identifier_matcher'
require_relative 'spec_helper/matchers/match_string_matcher'
require_relative 'spec_helper/matchers/match_value_matcher'
require_relative 'spec_helper/matchers/raise_rggen_error_matcher'
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

      def setup_coverage(use_codecov, filter)
        require 'simplecov'
        SimpleCov.start do
          filter && add_filter(Array(filter))
        end

        return unless use_codecov

        require 'codecov'
        SimpleCov.formatter = SimpleCov::Formatter::Codecov
      end

      def setup(config, coverage_filter: nil)
        setup_helpers(config)
        apply_default_config(config)
        ENV.key?('COVERAGE') &&
          setup_coverage(ENV.key?('USE_CODECOV'), coverage_filter)
      end
    end
  end
end
