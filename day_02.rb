# frozen_string_literal: true

require_relative 'helper'

instructions = input_lines('02').map(&:split).map { |(direction, mag)| [direction.to_sym, mag.to_i] }

first_result = instructions.each_with_object({ horizontal: 0, depth: 0 }) do |(direction, mag), pos|
  case direction
  when :forward then pos[:horizontal] += mag
  when :down then pos[:depth] += mag
  when :up then pos[:depth] -= mag
  end
end
puts first_result[:horizontal] * first_result[:depth]

second_result = instructions.each_with_object({ horizontal: 0, depth: 0, aim: 0 }) do |(direction, mag), pos|
  case direction
  when :forward
    pos[:horizontal] += mag
    pos[:depth] += mag * pos[:aim]
  when :down then pos[:aim] += mag
  when :up then pos[:aim] -= mag
  end
end
puts second_result[:horizontal] * second_result[:depth]
