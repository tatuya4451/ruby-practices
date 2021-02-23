#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def full_count(hash)
  hash.each do |file_name, file|
    file.each_value do |value|
      print value.to_s.rjust(8)
    end
    print " #{file_name}\n"
  end
end

def without_l_option(hash, files)
  if files.size == 1
    full_count(hash)
  else
    full_count(hash)
    print hash.values.inject(0) { |sum, hash| sum + hash[:lines] }.to_s.rjust(8)
    print hash.values.inject(0) { |sum, hash| sum + hash[:words] }.to_s.rjust(8)
    print hash.values.inject(0) { |sum, hash| sum + hash[:bytes] }.to_s.rjust(8)
    print " total \n"
  end
end

def line_count_only(hash)
  hash.each do |file_name, file|
    print file[:lines].to_s.rjust(8)
    print " #{file_name}\n"
  end
end

def l_option(hash, files)
  if files.size == 1
    line_count_only(hash)
  else
    line_count_only(hash)
    print hash.values.inject(0) { |sum, hash| sum + hash[:lines] }.to_s.rjust(8)
    print " total \n"
  end
end

def wc(files)
  hash = Hash.new { |h, k| h[k] = {} }
  argument_l = ARGV.getopts('l')['l']

  files.each do |file|
    str = File.read(file)
    hash[file][:lines] = str.each_line.count
    hash[file][:words] = str.split(/\s+/).size
    hash[file][:bytes] = str.size
  end

  argument_l ? l_option(hash, files) : without_l_option(hash, files)
end

def output_with_out_stdin
  files = ARGV
  files.empty? ? '' : wc(files)
end

def output_with_stdin
  pipe = []
  input = $stdin.read
  pipe << input.count("\n")
  pipe << input.split(/\s+/).size
  pipe << input.size
  pipe.each { |file| print file.to_s.rjust(8) }
  print "\n"
end

$stdin.tty? ? output_with_out_stdin : output_with_stdin
