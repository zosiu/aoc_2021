# frozen_string_literal: true

require_relative 'helper'

input = input('07').split(/\s*,\s*/).map(&:to_i)

min, max = input.minmax

res = (min...max).map do |p|
  input.inject([0, 0]) do |(first, second), e|
    dist = (e - p).abs
    [first + dist, second + dist * (dist + 1) / 2]
  end
end

puts res.min_by(&:first).first
puts res.min_by(&:last).last
