#!/usr/bin/env ruby

require 'date'
require 'optparse'

def create_calender(month: Date.today.month, year: Date.today.year)
  i = 3
  first_day = Date.new(year, month, 1)
  first_wday = Date.new(year, month, 1).wday
  last_day = Date.new(year, month, -1)
  week = ["日", "月", "火", "水", "木","金","土"]
  puts "#{month}月 #{year}".center(20)
  puts week.join(' ')

  (first_day..last_day).each do |day|
    if day.day == 1 && day.saturday?
      print day.day.to_s.rjust((first_wday * i) + i) + "\n"
    elsif day.day == 1
      print day.day.to_s.rjust((first_wday * i) + i)
    elsif day.saturday?
      print day.day.to_s.rjust(i) + "\n"
    else
      print day.day.to_s.rjust(i)
    end
  end
  print "\n"
end

opt = OptionParser.new

params = ARGV.getopts("y:","m:")
argument_year = params["y"].to_i
argument_month = params["m"].to_i

if argument_year == 0 && argument_month == 0
  create_calender
elsif argument_month == 0
  create_calender(year: argument_year)
elsif argument_year == 0
  create_calender(month: argument_month)
else
  create_calender(month: argument_month, year: argument_year)
end
