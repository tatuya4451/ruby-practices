# frozen_string_literal: true

(1..100).each do |x|
  if (x % 15).zero?
    puts 'FizzBuzz'
  elsif (x % 5).zero?
    puts 'Buzz'
  elsif (x % 3).zero?
    puts 'Fizz'
  else
    puts x
  end
end
