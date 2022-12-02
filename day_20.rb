# frozen_string_literal: true

require_relative 'helper'

algo, image = input('20').split(/\n\n/)
ocean_map = image.split(/\n/).each_with_index.each_with_object(Hash.new('.')) do |(line, i), res|
  line.chars.each_with_index do |c, j|
    res[[i, j]] = c
  end
end

def next_iteration(ocean_map, algo)
  relevant_keys = ocean_map.select { |_k, v| v == ocean_map[:default] }.map(&:first)
  min_x, max_x = relevant_keys.map(&:first).minmax
  min_y, max_y = relevant_keys.map(&:last).minmax

  ((min_x - 3)..(max_x + 3)).each_with_object(Hash.new(algo[(ocean_map[:default] * 9).to_i(2)])) do |x, res|
    ((min_y - 3)..(max_y + 3)).each do |y|
      binary_key = [[-1, -1], [0, -1], [1, -1],
                    [-1, 0], [0, 0], [1, 0],
                    [-1, 1], [0, 1], [1, 1]].map do |dy, dx|
        case ocean_map[[x + dx, y + dy]]
        when '#' then '1'
        when '.' then '0'
        end
      end.join
      res[[x, y]] = algo[binary_key.to_i(2)]
    end
  end
end

counts = 50.times.each_with_object([]) do |n, res|
  ocean_map = next_iteration(ocean_map, algo)
  res << ocean_map.count { |_, v| v == '#' } if [1, 49].include?(n)
end

puts counts
