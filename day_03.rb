# frozen_string_literal: true

require_relative 'helper'

instructions = input_lines('03')

digit_size = instructions.first.size
digits = instructions.each_with_object([0] * digit_size) do |binary, res|
  binary.chars.each_with_index do |char, index|
    res[index] += char.to_i
  end
end

middle = instructions.count / 2

gamma_rate = digits.map { |d| d > middle ? 1 : 0 }
epsilon_rate = gamma_rate.map { |d| d.zero? ? 1 : 0 }

puts gamma_rate.join.to_i(2) * epsilon_rate.join.to_i(2)

oxygen_generator_rating = instructions.dup
co2_scrubber_rating = instructions.dup

i = 0
while oxygen_generator_rating.count != 1
  ones = oxygen_generator_rating.count { |x| x[i] == '1' }
  zeros = oxygen_generator_rating.count { |x| x[i] == '0' }
  oxygen_generator_rating.select! { |x| x[i] == (ones >= zeros ? '1' : '0') }
  i += 1
end

i = 0
while co2_scrubber_rating.count != 1
  ones = co2_scrubber_rating.count { |x| x[i] == '1' }
  zeros = co2_scrubber_rating.count { |x| x[i] == '0' }
  co2_scrubber_rating.select! { |x| x[i] == (ones >= zeros ? '0' : '1') }
  i += 1
end

puts oxygen_generator_rating.first.to_i(2) * co2_scrubber_rating.first.to_i(2)
