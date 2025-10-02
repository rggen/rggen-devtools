# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module HelperMethods
        def mock_file_io(filename, content)
          allow(File).to receive(:readable?).with(filename).and_return(true)
          io = StringIO.new(content)
          allow(File).to receive(:open).with(filename, any_args).and_yield(io)
        end

        def mock_file_read(filename, content, no_args: false, mock_readable: true)
          allow(File).to receive(:readable?).with(filename).and_return(true) if mock_readable
          args = no_args && [filename] || [filename, any_args]
          allow(File).to receive(:read).with(*args).and_return(content)
        end

        def random_updown_case(string)
          string
            .chars
            .map { |char| [true, false].sample ? char.swapcase : char }
            .join
        end

        def random_string(pattern_or_length)
          pattern =
            case pattern_or_length
            when Regexp
              pattern_or_length
            else
              length = pattern_or_length
              /\A[a-z0-9]{#{length}}\z/i
            end
          pattern.random_example
        end

        def random_strings(pattern, number_of_results)
          strings = []
          until strings.size == number_of_results
            result = pattern.random_example
            if strings.include?(result)
              next
            else
              strings << result
            end
          end
          strings
        end

        def random_file_extensions(max_length: 3, exceptions: nil)
          Array.new(max_length) do |i|
            loop do
              string = random_string(i + 1)
              break string unless exceptions
              break string if exceptions.none?(&string.method(:casecmp?))
            end
          end
        end

        def raise_source_error(message = nil, additional_info = nil)
          raise_rggen_error(Core::SourceError, message, additional_info)
        end
      end
    end
  end
end
