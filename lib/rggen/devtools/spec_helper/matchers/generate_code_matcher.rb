# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        matcher :generate_code do |*args, expected_code|
          diffable

          match do |component|
            @actual = generate_code(component, args)
            @actual.include?(expected_code)
          end

          define_method(:expected) { expected_code }

          failure_message do
            'generated code is not matched with expected code'
          end

          def generate_code(component, args)
            code = Core::Utility::CodeUtility::CodeBlock.new
            component.generate_code(code, *args)
            code.to_s
          end
        end
      end
    end
  end
end
