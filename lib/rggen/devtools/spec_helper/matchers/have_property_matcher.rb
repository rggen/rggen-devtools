# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        matcher :have_property do |property, *value|
          match do |component_or_feature|
            case component_or_feature
            when Class
              @property_defined =
                component_or_feature
                  .public_instance_methods(false)
                  .include?(property)
              @value_matched = true
            else
              @property_defined =
                component_or_feature
                  .public_methods(false)
                  .include?(property)
              @value_matched =
                value.empty? || compare_value(component_or_feature)
            end
            @property_defined && @value_matched
          end

          failure_message do
            if !@property_defined
              "no such property is defined: #{property}"
            elsif !@value_matched
              "expected #{property} to be #{value[0].inspect} " \
              "but got #{@actual_value.inspect}"
            end
          end

          define_method(:compare_value) do |component_or_feature|
            return false unless @property_defined
            @actual_value = component_or_feature.public_send(property)
            values_match?(value[0], @actual_value)
          end
        end

        def have_properties(properties)
          properties.inject(nil) do |matcher, (property, value)|
            new_matcher = have_property(property, value)
            matcher&.and(new_matcher) || new_matcher
          end
        end
      end
    end
  end
end
