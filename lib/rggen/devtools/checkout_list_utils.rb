# frozen_string_literal: true

require 'yaml'

module RgGen
  module Devtools
    module CheckoutListUtils
      private

      def repository_root
        `git rev-parse --show-toplevel`.chomp
      end

      def repository_name
        ENV['RGGEN_REPOSITORY'] || File.basename(repository_root)
      end

      def branch_name
        ENV['RGGEN_BRANCH'] || `git rev-parse --abbrev-ref HEAD`.chomp
      end

      def devtools_root
        File.expand_path('../../../', __dir__)
      end

      def rggen_root
        @rggen_root ||=
          (ENV['RGGEN_ROOT'] || File.expand_path('../', devtools_root))
      end

      def read_checkout_list(list_file = nil)
        if list_file
          load_checkout_list(list)
        else
          root = rggen_root
          repository = repository_name
          branch = branch_name

          path = checkout_list_path(root, repository, branch)
          list = load_checkout_list(path)
          return list if list

          path = checkout_list_path(root, repository, 'master')
          list = load_checkout_list(path)
          list&.transform_values { |branches| [branch, *branches] }
        end
      end

      def load_checkout_list(list)
        return unless File.exist?(list)

        YAML
          .load_file(list)
          .transform_values { |branch| [branch] }
      end

      def checkout_list_path(root, repository, branch)
        File.join(root, 'rggen-checkout', repository, "#{branch}.yml")
      end
    end
  end
end
