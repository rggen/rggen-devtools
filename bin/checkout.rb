#! /usr/bin/env ruby

require 'fileutils'
require 'optparse'
require File.expand_path('../lib/rggen/devtools/checkout_list_utils', __dir__)
extend RgGen::Devtools::CheckoutListUtils

options = ARGV.getopts('', 'list:', 'dir:', 'ssh')

def exist_branch?(branch)
  command = "git branch -r | grep #{branch}"
  system(command)
end

def run_command(command)
  puts command
  abort unless system(command)

  true
end

read_checkout_list(options['list'])&.each do |repository, branches|
  FileUtils.cd(options['dir'] || rggen_root) do
    dir_name = File.basename(repository)
    unless Dir.exist?(dir_name)
      url =
        if options['ssh']
          "git@github.com:#{repository}.git"
        else
          "https://github.com/#{repository}.git"
        end

      command = "git clone #{url}"
      run_command(command)

      FileUtils.cd(dir_name) do
        branches.each do |branch|
          next if branch == 'master' || !exist_branch?(branch)

          command = "git switch #{branch}"
          break if run_command(command)
        end
      end
    else
      FileUtils.cd(dir_name) do
        branches.each do |branch|
          command = "git pull origin #{branch}"
          break if run_command(command)
        end
      end
    end
  end
end
