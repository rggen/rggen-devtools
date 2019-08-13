# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        extend ::RSpec::Matchers::DSL
      end
    end
  end
end

require_relative 'matchers/exit_with_code_matcher'
require_relative 'matchers/generate_code_matcher'
require_relative 'matchers/have_declaration_matcher'
require_relative 'matchers/have_identifier_matcher'
require_relative 'matchers/have_property_matcher'
require_relative 'matchers/have_value_matcher'
require_relative 'matchers/match_declaration_matcher'
require_relative 'matchers/match_identifier_matcher'
require_relative 'matchers/match_string_matcher'
require_relative 'matchers/match_value_matcher'
require_relative 'matchers/raise_rggen_error_matcher'
require_relative 'matchers/write_file_matcher'
