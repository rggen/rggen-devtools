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
        ENV['RGGEN_BRANCH'] || `git branch --show-current`.chomp
      end

      def rggen_root
        @rggen_root ||=
          (ENV['RGGEN_ROOT'] || File.expand_path('..', repository_root))
      end

      def read_checkout_list
        list = find_checkout_list
        list && YAML.load_file(list) || nil
      end

      def find_checkout_list
        root = rggen_root
        repository = repository_name
        [branch_name, 'master']
          .map { |branch| checkout_list_path(root, repository, branch) }
          .find(&File.method(:exist?))
      end

      def checkout_list_path(root, repository, branch)
        File.join(root, 'rggen-checkout', repository, "#{branch}.yml")
      end
    end
  end
end
