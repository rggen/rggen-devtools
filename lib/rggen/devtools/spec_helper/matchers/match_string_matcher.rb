# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        matcher :match_string do |expected|
          diffable

          @actual = nil

          match do |actual|
            @actual = actual.to_s
            values_match?(expected, @actual)
          end
        end
      end
    end
  end
end
