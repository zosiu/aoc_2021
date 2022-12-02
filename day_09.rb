# frozen_string_literal: true

require_relative 'helper'

def basin_from_low_point_rec(point, basin, data)
  return if data[point] > 8

  basin << point
  y, x = point
  [[0, 1], [1, 0], [-1, 0], [0, -1]].map do |(dy, dx)|
    new_point = [y + dy, x + dx]
    basin_from_low_point_rec(new_point, basin, data) unless basin.include?(new_point)
  end
end

def basin_from_low_point(low_point, data)
  basin = []
  basin_from_low_point_rec(low_point, basin, data)
  basin
end

data = input_lines('09').each_with_index.each_with_object(Hash.new(Float::INFINITY)) do |(x, i), res|
  x.each_char.with_index { |c, j| res[[j, i]] = c.to_i }
end

low_points = data.select do |(y, x), v|
  [[0, 1], [1, 0], [-1, 0], [0, -1]].all? do |(dy, dx)|
    data[[y + dy, x + dx]] > v
  end
end

basins = low_points.keys.each_with_object([]) do |low_point, res|
  res << basin_from_low_point(low_point, data)
end

puts low_points.sum { |_k, v| v + 1 }
puts basins.sort_by(&:count).reverse.first(3).map(&:count).inject(:*)
