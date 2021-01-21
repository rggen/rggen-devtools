#! /usr/bin/env ruby

require File.expand_path('../lib/rggen/devtools/checkout_list_utils', __dir__)
extend RgGen::Devtools::CheckoutListUtils

read_checkout_list&.each do |repository, branch|
  command = "git clone --branch=#{branch} https://github.com/rggen/#{repository}.git"
  puts command
  system(command)
end
