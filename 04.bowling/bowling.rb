#!/usr/bin/env ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.chars

shots = scores.map { |s| s == 'X' ? 10 : s.to_i }

total_score = 0
frame_score = 0
frame_count = 1
shots_count = 0

shots.each_with_index do |s, i|
  shots_count += 1
  frame_score += s

  if frame_count == 10
    if shots_count == 1 && s == 10
      total_score += 10 + shots[i + 1] + shots[i + 2]
      break
    elsif shots_count == 2 && frame_score == 10
      total_score += 10 + shots[i + 1]
      break
    end
  elsif shots_count == 1 && s == 10
    total_score += 10 + shots[i + 1] + shots[i + 2]
    frame_count += 1
    shots_count = 0
    frame_score = 0
  elsif shots_count == 2 && frame_score == 10
    total_score += 10 + shots[i + 1]
    frame_count += 1
    shots_count = 0
    frame_score = 0
  elsif shots_count == 2
    total_score += frame_score
    frame_count += 1
    shots_count = 0
    frame_score = 0
  end
end

puts total_score
