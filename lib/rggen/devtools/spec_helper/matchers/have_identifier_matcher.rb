# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        matcher :have_identifier do |accsessor, name = nil|
          match do |component_or_feature|
            @actual_identifier =
              if component_or_feature.respond_to?(accsessor)
                component_or_feature.__send__(accsessor)
              end
            @actual_identifier && values_match?(@actual_identifier.to_s, name.to_s)
          end

          failure_message do
            if !@actual_identifier
              "identifier accsessor named #{accsessor} is not defined"
            else
              "identifier name is not mathced\n" \
              "  expected: #{name}\n" \
              "    actual: #{@actual_identifier}\n\n"
            end
          end

          match_when_negated do |component_or_feature|
            !component_or_feature.respond_to?(accsessor)
          end

          failure_message_when_negated do
            "expected identifier accsessor named #{accsessor} " \
            'not to be defined but it is defined'
          end
        end

        define_negated_matcher :not_have_identifier, :have_identifier
      end
    end
  end
end
