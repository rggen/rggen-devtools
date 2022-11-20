# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        matcher :match_value do |value, position = nil|
          match do |actual|
            return false unless values_match?(value, actual.value)
            return false if position && (actual.position != position)
            true
          end

          failure_message do
            if position
              "expected: #{value.inspect} [#{position}]\n"  \
              "     got: #{actual.value.inspect} [#{actual.position}]\n\n"
            else
              "expected: #{value.inspect}\n"  \
              "     got: #{actual.value.inspect}\n\n"
            end
          end
        end
      end
    end
  end
end
