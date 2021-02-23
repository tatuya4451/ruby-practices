#!/usr/bin/env ruby

def wc(hash)
  hash.each do |file_name, file|
    file.each_value do |value|
      print value.to_s.rjust(8)
    end
    print " #{file_name}\n"
  end
end

def file
  files = ARGV
  hash = Hash.new { |h,k| h[k] = {} }

  files.each do |file|
    str = File.read(file)
    hash[file][:lines] = str.each_line.count
    hash[file][:words] = str.split(/\s+/).size
    hash[file][:bytes] = str.size
  end

  if files.size == 1
    wc(hash)
  else
    wc(hash)
    print hash.values.inject(0) {|sum, hash| sum + hash[:lines]}.to_s.rjust(8)
    print hash.values.inject(0) {|sum, hash| sum + hash[:words]}.to_s.rjust(8)
    print hash.values.inject(0) {|sum, hash| sum + hash[:bytes]}.to_s.rjust(8)
    print " total \n"
  end
end

file
