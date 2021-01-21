# frozen_string_literal: true

require_relative 'checkout_list_utils'

module RgGen
  module Devtools
    module GemfileHelper
      include CheckoutListUtils

      def install_rggen
        read_checkout_list&.each_key do |repository|
          rggen_gem?(repository) && gem_rggen(repository)
        end
      end

      def gem_rggen(gem_name, add_group: true)
        options = {}
        options[:path] = File.join(rggen_root, gem_name)
        options[:group] = :rggen_root if add_group
        gem gem_name, **options
      end

      def gem_patched(gem_name, group: nil)
        return unless ENV['USE_GEM_PATCHED_LOCALLY'] == 'yes'

        options = {}

        path = File.join(rggen_root, gem_name)
        if Dir.exist?(path)
          options[:path] = path
        else
          options[:github] = "taichi-ishitani/#{gem_name}"
        end

        if group
          options[:group] = group
        end

        gem gem_name, **options
      end

      private

      def rggen_gem?(gem_name)
        spec_path = File.join(rggen_root, gem_name, "#{gem_name}.gemspec")
        File.exist?(spec_path)
      end
    end
  end
end
