# frozen_string_literal: true

require_relative 'helper'

sea_bottom = input_lines('25').each_with_index.each_with_object({}) do |(line, x), res|
  line.each_char.each_with_index do |c, y|
    res[[x, y]] = c
  end
end

def iterate(sea_bottom)
  move_counter = 0
  new_iter_half = sea_bottom.dup
  east = sea_bottom.keys.select { sea_bottom[_1] == '>' }
  east.each do |(x, y)|
    new_key = [x, y + 1]
    new_key[1] = 0 unless sea_bottom[new_key]
    next unless sea_bottom[new_key] == '.'

    new_iter_half[[x, y]] = '.'
    new_iter_half[new_key] = '>'
    move_counter += 1
  end
  new_iter = new_iter_half.dup
  south = sea_bottom.keys.select { new_iter_half[_1] == 'v' }
  south.each do |(x, y)|
    new_key = [x + 1, y]
    new_key[0] = 0 unless new_iter_half[new_key]
    next unless new_iter_half[new_key] == '.'

    new_iter[[x, y]] = '.'
    new_iter[new_key] = 'v'
    move_counter += 1
  end
  [new_iter, move_counter]
end

num_of_iterations = 0
loop do
  sea_bottom, moves = iterate(sea_bottom)
  num_of_iterations += 1
  break if moves.zero?
end

puts num_of_iterations
