# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        matcher :raise_rggen_error do |error_type, message, additional_info = nil|
          supports_block_expectations

          match do |block|
            @expected_error_raised = false
            @actual_message = nil

            begin
              block.call
            rescue error_type => e
              @expected_error_raised = true
              @actual_message = additional_info ? e.to_s : e.error_message
            end

            @expected_message =
              if message && additional_info
                "#{message} -- #{additional_info}"
              else
                message
              end

            return false unless @expected_error_raised
            return false if @actual_message != @expected_message
            true
          end

          failure_message do
            if !@expected_error_raised
              "expected #{error_type} with '#{@expected_message}' " \
              'to be raised but it was not raised'
            else
              "#{error_type} was raised but error message is not matched\n" \
              "  expected message: #{@expected_message}\n" \
              "    actual message: #{@actual_message}\n\n"
            end
          end
        end
      end
    end
  end
end
