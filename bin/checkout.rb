#! /usr/bin/env ruby

require 'fileutils'
require 'optparse'
require File.expand_path('../lib/rggen/devtools/checkout_list_utils', __dir__)
extend RgGen::Devtools::CheckoutListUtils

options = ARGV.getopts('', 'list:', 'dir:')

read_checkout_list(options['list'])&.each do |repository, branch|
  FileUtils.cd(options['dir'] || rggen_root) do
    unless Dir.exist?(File.basename(repository))
      command = "git clone --branch=#{branch} https://github.com/#{repository}.git"
      puts command
      system(command) || abort
    end
  end
end
