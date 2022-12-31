#! /usr/bin/env ruby

require 'optparse'
require 'fileutils'

TARGET_FILES = ['README.md', 'LICENSE.txt', 'LICENSE']

def update_copyright_year(path, ticket)
  return unless File.directory?(path)

  FileUtils.cd(path) do
    TARGET_FILES.each do |file|
      next unless File.file?(file)

      rewrite_target_file(file)
      command = "git add #{file}"
      puts command
      system(command)
    end

    command = "git commit --amend -m \"update copyright year #{eto}\n\n(refs: #{ticket})\""
    puts command
    system(command)
  end
end

def rewrite_target_file(file)
  this_year = Time.now.year
  lines = File.readlines(file).map do |line|
    if /copyright/i =~ line && /\d{4}/ =~ line
      match, update =
        case line
        when /(\d{4}) *- *\d{4}/
          [$~.to_s, "#{$1}-#{this_year}"]
        when /(\d{4})/
          [$~.to_s, "#{$1}-#{this_year}"]
        end
      line[match] = update
    end
    line
  end
  File.write(file, lines.join)
end

def eto
  this_year = Time.now.year
  [
    ':mouse:', ':cow:', ':tiger:', ':rabbit:', ':dragon:', ':snake:',
    ':horse:', ':sheep:', ':monkey:', ':rooster:', ':dog:', ':boar:'
  ][(this_year - 2020) % 12]
end

options = ARGV.getopts('', 'root:', 'ticket:')
root = File.expand_path(options['root'])
ticket = options['ticket']

Dir.children(root).each do |path|
  update_copyright_year(path, ticket)
end
