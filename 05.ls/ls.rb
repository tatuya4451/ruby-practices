#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

# トータルのバイトを計算
def total_bites(files)
  total_bites = files.map { |file| File.stat(file).blocks }
  print "total #{total_bites.sum}"
  print "\n"
end

# 2進数にしたパーミッションをrwxに変換
def conversion_rwx(binary)
  rwx = []
  rwx << (binary[0] == '1' ? 'r' : '-')
  rwx << (binary[1] == '1' ? 'w' : '-')
  rwx << (binary[2] == '1' ? 'x' : '-')
end

# -lオプションの各種ステータス
def file_statuses(file)
  statuses = []
  statuses << File.stat(file).nlink.to_s.rjust(3)
  statuses << Etc.getpwuid(File.stat(file).uid).name
  statuses << Etc.getgrgid(File.stat(file).gid).name
  statuses << File.stat(file).size.to_s
  time = File.stat(file).mtime
  statuses << time.month.to_s
  statuses << time.day.to_s
  statuses << time.strftime('%H:%M').to_s
  statuses << file
  puts statuses.join(' ')
end

# -lオプション
def l_option(files)
  total_bites(files)

  files.each do |file|
    mode_octal = File.stat(file).mode.to_s(8)
    binary_owner = mode_octal[-3].to_i.to_s(2)
    binary_group = mode_octal[-2].to_i.to_s(2)
    binary_others = mode_octal[-1].to_i.to_s(2)

    print conversion_rwx(binary_owner).join('')
    print conversion_rwx(binary_group).join('')
    print conversion_rwx(binary_others).join('')

    file_statuses(file)
  end
end

# ファイルの数によって配列に格納
def files_split(files)
  files_box = []
  if (files.size % 3).zero?
    files.each_slice(files.size / 3) { |d| files_box << d }
  else
    files_size = (files.size / 3) + 1
    files.each_slice(files_size) { |d| files_box << d }
  end
  files_box
end

# ファイルの配列を整形
def alignment(split_files, max_size)
  split_files.reduce(:zip)&.map(&:flatten)&.each { |row| puts row.map { |string| string&.ljust(max_size) }.join(' ') }
end

# -a, -rオプション
def without_l_option(files)
  return if files.empty?

  max_size = files.max_by(&:size).size.to_i
  if files.size == 1
    puts files
  else
    split_files = files_split(files)
    alignment(split_files, max_size)
  end
end

params = ARGV.getopts('a', 'l', 'r')
argument_a = params['a']
argument_r = params['r']
argument_l = params['l']

files = (argument_a ? Dir['*', '.*'] : Dir['*']).sort
files.reverse! if argument_r

argument_l ? l_option(files) : without_l_option(files)
