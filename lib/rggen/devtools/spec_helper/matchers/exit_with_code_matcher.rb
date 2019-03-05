# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        matcher :exit_with_code do |expected_code|
          supports_block_expectations

          actual = nil

          match do |block|
            begin
              block.call
            rescue SystemExit => e
              actual = e.status
            end
            actual && actual == expected_code
          end

          failure_message do
            if actual
              "expected block to call exit with #{expected_code} " \
              "but exit with #{actual} was called"
            else
              "expected block to call exit with #{expected_code} " \
              'but exit was not called'
            end
          end
        end
      end
    end
  end
end
