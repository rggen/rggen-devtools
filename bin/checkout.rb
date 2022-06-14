#! /usr/bin/env ruby

require 'fileutils'
require 'optparse'
require File.expand_path('../lib/rggen/devtools/checkout_list_utils', __dir__)
extend RgGen::Devtools::CheckoutListUtils

options = ARGV.getopts('', 'list:', 'dir:', 'ssh')

read_checkout_list(options['list'])&.each do |repository, branch|
  FileUtils.cd(options['dir'] || rggen_root) do
    dir_name = File.basename(repository)
    unless Dir.exist?(dir_name)
      url =
        if options['ssh']
          "git@github.com:#{repository}.git"
        else
          "https://github.com/#{repository}.git"
        end
      command = "git clone --branch=#{branch} #{url}"
      puts command
      system(command) || abort
    else
      FileUtils.cd(dir_name) do
        command = "git pull origin #{branch}"
        puts command
        system(command) || abort
      end
    end
  end
end
