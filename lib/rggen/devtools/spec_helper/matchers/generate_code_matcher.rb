# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        matcher :generate_code do |scope, mode, expected_code|
          diffable

          match do |component|
            @actual = generate_code(component, scope, mode)
            @actual.include?(expected_code)
          end

          define_method(:expected) { expected_code }

          failure_message do
            'generated code is not matched with expected code'
          end

          def generate_code(component, scope, mode)
            code = Core::Utility::CodeUtility::CodeBlock.new
            component.generate_code(scope, mode, code)
            code.to_s
          end
        end
      end
    end
  end
end
