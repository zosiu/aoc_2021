# frozen_string_literal: true

require_relative 'helper'

instructions = input_lines('22').map do |line|
  command, xyz = line.split
  [command.to_sym,
   xyz.scan(/x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)/).first.map(&:to_i).each_slice(2).map do
     Range.new(*_1)
   end]
end

class Region
  attr_reader :dimensions

  def initialize(dimensions)
    @dimensions = dimensions
  end

  def overlap(other_region)
    new_dimensions = dimensions.zip(other_region.dimensions).map do |(lhs, rhs)|
      from1, to1 = lhs.minmax
      from2, to2 = rhs.minmax
      [from1, from2].max..[to1, to2].min
    end
    Region.new(new_dimensions) unless new_dimensions.any? { _1.count.zero? }
  end

  def cube_count
    dimensions.map(&:count).inject(:*)
  end
end

data = instructions.each_with_object({ plus: [], minus: [] }) do |(cmd, xyz), res|
  current_region = Region.new(xyz)
  new_on = res[:minus].map { _1.overlap(current_region) }.compact
  new_off = res[:plus].map { _1.overlap(current_region) }.compact
  res[:plus].concat(new_on)
  res[:minus].concat(new_off)
  res[:plus] << current_region if cmd == :on
end

initialization_procedure_region = Region.new([Range.new(-50, 50)] * 3)
puts data[:plus].map { _1.overlap(initialization_procedure_region) }.compact.sum(&:cube_count) -
     data[:minus].map { _1.overlap(initialization_procedure_region) }.compact.sum(&:cube_count)
puts data[:plus].sum(&:cube_count) - data[:minus].sum(&:cube_count)
