#!/usr/bin/env ruby

require 'date'
require 'optparse'

def create_calender(month, year)
  width = 3
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)
  puts "#{month}月 #{year}".center(20)
  puts  "日 月 火 水 木 金 土"

  (first_date..last_date).each do |date|
    if date.day == 1
      print date.day.to_s.rjust((first_date.wday * width) + width)
    else
      print date.day.to_s.rjust(width)
    end
    if date.saturday?
      print "\n"
    end
  end
  print "\n"
end


params = ARGV.getopts("y:", "m:")
argument_year = params["y"]
argument_month = params["m"]

month = argument_month ? argument_month.to_i : Date.today.month
year = argument_year ? argument_year.to_i : Date.today.year

create_calender(month, year)
