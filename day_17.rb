# frozen_string_literal: true

require_relative 'helper'

def simulate(dx, dy, tmin_x, tmax_x, tmin_y, tmax_y)
  pos_x = 0
  pos_y = 0
  highest_y = -Float::INFINITY
  loop do
    pos_x += dx
    pos_y += dy
    dy -= 1
    dx -= dx <=> 0
    highest_y = [highest_y, pos_y].max
    return highest_y if pos_x.between?(tmin_x, tmax_x) && pos_y.between?(tmin_y, tmax_y)
    break if pos_x > tmax_x || pos_y < tmin_y
  end
end

bounds = input('17').scan(/target area: x=(-?\d+)\.\.(-?\d+), y=(-?\d+)\.\.(-?\d+)/).first.map(&:to_i)
_, max_x, min_y, = bounds
highest_ys = Range.new(*[min_y, -min_y].sort).each_with_object([]) do |dy, res|
  (0..max_x).each { |dx| res << simulate(dx, dy, *bounds) }
end.compact

puts highest_ys.max
puts highest_ys.count
