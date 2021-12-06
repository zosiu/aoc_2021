# frozen_string_literal: true

require_relative 'helper'

vents = input_lines('05').map { |line| line.scan(/(\d+),(\d+) -> (\d+),(\d+)/).flatten.map(&:to_i) }

max_x = vents.max_by { |(_, _, x, _)| x }[2] + 1
max_y = vents.max_by { |(_, _, _, y)| y }[3] + 1
max = [max_x, max_y].max

diagram1 = Array.new(max) { Array.new(max, 0) }
diagram2 = Array.new(max) { Array.new(max, 0) }

vents.each do |(x1, y1, x2, y2)|
  if x1 == x2
    min, max = [y1, y2].minmax
    (min..max).each do |y|
      diagram1[y][x1] += 1
      diagram2[y][x1] += 1
    end
  elsif y1 == y2
    min, max = [x1, x2].minmax
    (min..max).each do |x|
      diagram1[y1][x] += 1
      diagram2[y1][x] += 1
    end
  elsif (x1 - x2).abs == (y1 - y2).abs
    dir_x = x2 > x1 ? 1 : -1
    dir_y = y2 > y1 ? 1 : -1
    ((x1 - x2).abs + 1).times do |i|
      diagram2[y1 + i * dir_y][x1 + i * dir_x] += 1
    end
  end
end

puts diagram1.flatten.count { |p| p >= 2 }
puts diagram2.flatten.count { |p| p >= 2 }
