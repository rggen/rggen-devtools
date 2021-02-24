#! /usr/bin/env ruby

require 'fileutils'
require File.expand_path('../lib/rggen/devtools/checkout_list_utils', __dir__)
extend RgGen::Devtools::CheckoutListUtils

read_checkout_list&.each do |repository, branch|
  command = "git clone --branch=#{branch} https://github.com/#{repository}.git"
  puts command
  FileUtils.cd(rggen_root) { system(command) || abort }
end
