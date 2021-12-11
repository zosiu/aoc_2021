# frozen_string_literal: true

require_relative 'helper'

def step(octopi)
  flashes = octopi.transform_values { false }
  octopi.transform_values!(&:succ)
  flashing_octopi = octopi.select { |_, v| v == 10 }.keys
  until flashing_octopi.empty?
    x, y = flashing_octopi.pop
    flashes[[x, y]] = true
    [[-1, -1], [0, -1], [1, -1],
     [-1,  0],          [1, 0],
     [-1,  1], [0, 1], [1, 1]].each do |(dx, dy)|
      octopus = [x + dx, y + dy]
      next unless octopi[octopus] && !flashes[octopus]

      octopi[octopus] += 1
      flashing_octopi << octopus if octopi[octopus] == 10
    end
  end
  flashes.select { |_, v| v }.each_key { |c| octopi[c] = 0 }
end

octopi = input_lines('11').map.with_index.with_object({}) do |(line, j), res|
  line.chars.each_with_index do |c, i|
    res[[i, j]] = c.to_i
  end
end

flashes = []
Kernel.loop do
  step(octopi)
  flashes << octopi.values.count(&:zero?)
  break if flashes.last == octopi.keys.count
end

puts flashes.first(100).sum
puts flashes.count
