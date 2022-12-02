# frozen_string_literal: true

require_relative 'helper'
require 'pairing_heap'

risk_levels = input_lines('15').each_with_index.each_with_object({}) do |(line, x), res|
  line.chars.map(&:to_i).each_with_index do |risk_level, y|
    res[[x, y]] = risk_level
  end
end

def min_path(risk_levels)
  min_risk_levels = risk_levels.transform_values { { total_risk: Float::INFINITY, coming_from: nil } }
  min_risk_levels[[0, 0]] = { total_risk: 0, coming_from: :start }

  nodes = PairingHeap::MinPriorityQueue.new
  min_risk_levels.each { |n, data| nodes.push(n, data[:total_risk]) }

  until nodes.empty?
    node = nodes.pop
    [[0, 1], [1, 0], [-1, 0], [0, -1]].each do |(dx, dy)|
      neighbor = [node.first + dx, node.last + dy]
      next unless min_risk_levels[neighbor]

      dist = min_risk_levels[node][:total_risk] + risk_levels[node]
      next unless min_risk_levels[neighbor][:total_risk] > dist

      min_risk_levels[neighbor][:total_risk] = dist
      min_risk_levels[neighbor][:coming_from] = node
      nodes.change_priority(neighbor, dist)
    end
  end

  max_x = risk_levels.keys.map(&:first).max
  max_y = risk_levels.keys.map(&:last).max
  coming_from = min_risk_levels[[max_x, max_y]][:coming_from]
  path = [[max_x, max_y]]
  until coming_from == :start
    coming_from = min_risk_levels[path.first][:coming_from]
    path = [coming_from] + path
  end
  path
end

def path_sum(path, risk_levels)
  path.map { |x| risk_levels[x] }.compact.sum - risk_levels[[0, 0]]
end

def full_risk_levels(risk_levels)
  max_x = risk_levels.keys.map(&:first).max + 1
  max_y = risk_levels.keys.map(&:last).max + 1
  (max_x * 5).times.each_with_object({}) do |x, res|
    (max_y * 5).times.each do |y|
      orig = risk_levels[[x % max_x, y % max_x]]
      orig += x / max_x
      orig += y / max_y
      orig = orig % 9 if orig > 9
      res[[x, y]] = orig
    end
  end
end

puts path_sum(min_path(risk_levels), risk_levels)

real_risk_levels = full_risk_levels(risk_levels)
puts path_sum(min_path(real_risk_levels), real_risk_levels)
