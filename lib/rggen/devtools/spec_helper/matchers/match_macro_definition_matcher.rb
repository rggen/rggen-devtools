# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        matcher :match_macro_definition do |expected_name, expected_value = nil|
          match do |actual|
            @actual_definition = actual
            expected_name == @actual_definition.name
              values_match?(expected_value, @actual_definition.value)
          end

          failure_message do
            "expected: name #{expected_name} value #{expected_value.inspect}\n"
            "     got: name #{@actual_definition.name} value #{@actual_definition.value.inspect}\n\n"

          end
        end
      end
    end
  end
end
