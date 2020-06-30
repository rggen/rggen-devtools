# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        matcher :have_declaration do |*args|
          match do |component|
            @target, @layer, @type, @expected_declaration =
              if args.size == 3 && args.first
                [component.__send__(args.first), *args[0..2]]
              elsif args.size == 3
                [component, component.layer, *args[1..2]]
              else
                [component, component.layer, *args[0..1]]
              end
            @target
              .declarations[@type]
              .any? { |declaration| values_match?(@expected_declaration.to_s, declaration.to_s) }
          end

          failure_message do
            'expected such declaration to be found from ' \
            "(layer #{@layer.inspect}, type #{@type.inspect}) but it is not found\n" \
            "  declaration: #{@expected_declaration}\n\n"
          end

          failure_message_when_negated do
            'expected such declaration not to be found from ' \
            "(layer #{@layer.inspect}, type #{@type.inspect}) but it is found\n" \
            "  declaration: #{@expected_declaration}\n\n"
          end
        end

        define_negated_matcher :not_have_declaration, :have_declaration
      end
    end
  end
end
