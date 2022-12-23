# frozen_string_literal: true

module RgGen
  module Devtools
    module SpecHelper
      module Matchers
        matcher :have_property do |property, *args_and_value|
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
              @value_matched = compare_value(component_or_feature, args_and_value)
            end
            @property_defined && @value_matched
          end

          failure_message do
            if !@property_defined
              "no such property is defined: #{property}"
            elsif !@value_matched
              "expected #{property} to be #{args_and_value[-1].inspect} " \
              "but got #{@actual_value.inspect}"
            end
          end

          define_method(:compare_value) do |component_or_feature, args_and_value|
            return false unless @property_defined
            return true if args_and_value.empty?

            args, kw =
              if args_and_value.size == 1
                [[], {}]
              elsif args_and_value[0].is_a?(Array)
                [args_and_value[0], {}]
              elsif args_and_value[0].is_a?(Hash)
                [[], args_and_value[0]]
              end
            @actual_value = component_or_feature.public_send(property, *args, **kw)
            @actual_value = @actual_value.__getobj__ if @actual_value.respond_to?(:__getobj__)
            values_match?(args_and_value[-1], @actual_value)
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
