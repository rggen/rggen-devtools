# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        matcher :have_declaration do |domain, type, expected_declaration|
          match do |component_or_feature|
            component_or_feature
              .declarations(domain, type)
              .any? { |declaration| values_match?(expected_declaration.to_s, declaration.to_s) }
          end

          failure_message do
            'expected such declaration to be found from ' \
            "#declarations(#{domain.inspect}, #{type.inspect}) but it is not found\n" \
            "  declaration: #{expected_declaration}\n\n"
          end

          failure_message_when_negated do
            'expected such declaration not to be found from ' \
            "#declarations(#{domain.inspect}, #{type.inspect}) but it is found\n" \
            "  declaration: #{expected_declaration}\n\n"
          end
        end

        define_negated_matcher :not_have_declaration, :have_declaration
      end
    end
  end
end
