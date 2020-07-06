# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module HelperMethods
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

        def load_setup_files(builder, files)
          files.each { |file| load file }
          builder.activate_plugins(no_default_setup: true)
        end
      end
    end
  end
end
