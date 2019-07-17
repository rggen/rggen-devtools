# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        matcher :write_file do |file_name, content|
          supports_block_expectations

          match do |block|
            @actual_args = []
            setup_spy

            block.call
            verify(file_name, content)
          end

          failure_message do
            if @actual_args.empty?
              "file: #{file_name} was not written"
            elsif !@file_name_matched
              "file name was not mathced\n" \
              "expected: #{file_name}\n" \
              "     got: #{@actual_args[0]}\n\n"
            else
              message = "file content of #{file_name} was not mathced"
              ::RSpec::Matchers::ExpectedsForMultipleDiffs
                .from(content)
                .message_with_diff(message, ::RSpec::Expectations.differ, @actual_args[1])
            end
          end

          def setup_spy
            allow(File).to receive(:binwrite).and_wrap_original do |_, *args|
              @actual_args.concat(args.map(&:to_s))
            end
          end

          def verify(file_name, content)
            return false unless @actual_args.size == 2
            @file_name_matched = values_match?(file_name, @actual_args[0])
            @cntents_matched = values_match?(content, @actual_args[1])
            @file_name_matched && @cntents_matched
          end
        end
      end
    end
  end
end
