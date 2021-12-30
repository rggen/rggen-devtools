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

      def gem_rggen(repository, add_group: true)
        options = {}

        gem_name = extract_gem_name(repository)
        path = File.join(rggen_root, gem_name)
        if Dir.exist?(path)
          options[:path] = path
        elsif ENV['CI']
          options[:github] = repository
        end

        if add_group
          options[:group] = :rggen
        end

        gem gem_name, **options
      end

      def gem_patched(gem_name, group: nil, branch: nil)
        return unless ENV['USE_GEM_PATCHED_LOCALLY'] == 'yes'

        options = {}

        path = File.join(rggen_root, gem_name)
        if Dir.exist?(path)
          options[:path] = path
        else
          options[:github] = "taichi-ishitani/#{gem_name}"
          options[:branch] = branch if branch
        end

        if group
          options[:group] = group
        end

        gem gem_name, **options
      end

      private

      def extract_gem_name(repository)
        File.basename(repository)
      end

      def rggen_gem?(repository)
        gem_name = extract_gem_name(repository)
        spec_path = File.join(rggen_root, gem_name, "#{gem_name}.gemspec")
        File.exist?(spec_path)
      end
    end
  end
end
