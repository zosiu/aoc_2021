# frozen_string_literal: true

require_relative 'helper'
require 'set'

def traverse_rec(path, paths, graph, can_visit_one_small_cave_twice:)
  graph[path.first].each do |node|
    next if node == 'start'

    new_path = [node] + path
    if node == 'end'
      paths << new_path
      next
    end

    if node == node.upcase || !path.include?(node)
      traverse_rec(new_path, paths, graph, can_visit_one_small_cave_twice: can_visit_one_small_cave_twice)
    elsif can_visit_one_small_cave_twice
      traverse_rec(new_path, paths, graph, can_visit_one_small_cave_twice: false)
    end
  end
end

def traverse(start_node, graph, can_visit_one_small_cave_twice: false)
  paths = []
  traverse_rec([start_node], paths, graph, can_visit_one_small_cave_twice: can_visit_one_small_cave_twice)
  paths
end

graph = input_lines('12').each_with_object(Hash.new { |hsh, k| hsh[k] = Set.new }) do |line, res|
  from, to = line.split('-')
  res[from] << to
  res[to] << from
end

puts traverse('start', graph).count
puts traverse('start', graph, can_visit_one_small_cave_twice: true).count
