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

      def devtools_root
        File.expand_path('../../../', __dir__)
      end

      def rggen_root
        @rggen_root ||=
          (ENV['RGGEN_ROOT'] || File.expand_path('../', devtools_root))
      end

      def read_checkout_list(list_file = nil)
        list = list_file || find_checkout_list
        list && YAML.load_file(list) || nil
      end

      def find_checkout_list
        root = rggen_root
        repository = repository_name
        [*checkout_lists(root, repository), default_checkout_list(root, repository)]
          .find(&File.method(:exist?))
      end

      def checkout_lists(root, repository)
        [branch_name, 'master'].map do |branch|
          File.join(root, 'rggen-checkout', repository, "#{branch}.yml")
        end
      end

      def default_checkout_list(root, repository)
        File.join(root, repository, 'rggen_checkout.yml')
      end
    end
  end
end
