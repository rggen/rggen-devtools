# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        matcher :match_declaration do |expected_declaration|
          match do |actual|
            @actual_declaration =
              if actual.respond_to?(:declaration)
                actual.declaration
              else
                actual
              end
            values_match?(expected_declaration, @actual_declaration.to_s)
          end

          failure_message do
            "expected: #{expected_declaration}\n" \
            "     got: #{@actual_declaration}\n\n"
          end
        end
      end
    end
  end
end
