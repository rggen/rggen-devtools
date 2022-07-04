# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        matcher :match_string do |expected|
          diffable

          @actual = nil

          match do |actual|
            @actual =
              if actual.respond_to?(:to_code)
                actual.to_code.to_s
              else
                actual.to_s
              end
            values_match?(expected, @actual)
          end
        end
      end
    end
  end
end
