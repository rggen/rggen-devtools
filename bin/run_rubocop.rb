#! /usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'optparse'
require File.expand_path('../lib/rggen/devtools/checkout_list_utils', __dir__)

extend RgGen::Devtools::CheckoutListUtils

def join_path(*item)
  File.join(*item.compact)
end

options = ARGV.getopts('', 'root:')
root = options['root']

list = join_path(root, 'rggen-checkout', 'all.yml')
read_checkout_list(list).each_key do |repository|
  FileUtils.cd(join_path(root, File.basename(repository))) do
    if File.exist?('Rakefile')
      command = 'bundle exec rake rubocop'
      puts command
      system(command) || abort
    end
  end
end
