#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'find'

def wc_count(hash)
  hash.each do |file_name, file|
    file.each_value do |value|
      print value.to_s.rjust(8)
    end
    print " #{file_name}\n"
  end
end

def total_count(hash)
  wc_count(hash)
  print hash.values.inject(0) { |sum, value| sum + value[:lines] }.to_s.rjust(8)
  print hash.values.inject(0) { |sum, value| sum + value[:words] }.to_s.rjust(8)
  print hash.values.inject(0) { |sum, value| sum + value[:bytes] }.to_s.rjust(8)
  print " total \n"
end

def without_l_option(hash, files)
  files.size == 1 ? wc_count(hash) : total_count(hash)
end

def line_count_only(hash)
  hash.each do |file_name, file|
    print file[:lines].to_s.rjust(8)
    print " #{file_name}\n"
  end
end

def total_line_count_only(hash)
  line_count_only(hash)
  print hash.values.inject(0) { |sum, value| sum + value[:lines] }.to_s.rjust(8)
  print " total \n"
end

def l_option(hash, files)
  files.size == 1 ? line_count_only(hash) : total_line_count_only(hash)
end

def wc(files)
  hash = Hash.new { |h, k| h[k] = {} }
  argument_l = ARGV.getopts('l')['l']

  files.each do |file|
    str = File.read(file)
    hash[file][:lines] = str.count("\n")
    hash[file][:words] = str.split(/\s+/).size
    hash[file][:bytes] = str.size
  end

  argument_l ? l_option(hash, files) : without_l_option(hash, files)
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

def directory_under_file_include
  files = []
  Find.find('./').map { |f| files << f.slice(2..-1) if ARGV.include?(f.slice(2..-1))}
  files.empty? ? output_with_stdin : wc(files)
end

directory_under_file_include
