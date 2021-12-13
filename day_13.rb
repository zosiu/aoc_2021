# frozen_string_literal: true

require_relative 'helper'

def draw(paper)
  puts
  paper.each do |line|
    line.each { |dot| print dot }
    puts
  end
end

def fold_y(paper, num)
  top = paper[0...num]
  bottom = paper[(num + 1)..-1].reverse

  top.each_with_index do |line, x|
    line.each_with_index do |_dot, y|
      top[x][y] = '#' if bottom[x][y] == '#'
    end
  end

  top
end

def fold_x(paper, num)
  left = paper.map { |line| line[0...num] }
  right = paper.map { |line| line[(num + 1)..-1].reverse }

  left.each_with_index do |line, x|
    line.each_with_index do |_dot, y|
      left[x][y] = '#' if right[x][y] == '#'
    end
  end

  left
end

coords, folds = input('13').split(/\n\n/)

coords = coords.split(/\n/).map { |line| line.split(/\s*,\s*/).map(&:to_i) }
max_x = coords.map(&:first).max + 1
max_y = coords.map(&:last).max + 1

paper = Array.new(max_y) { Array.new(max_x, '.') }
coords.each { |(y, x)| paper[x][y] = '#' }

folds = folds.scan(/fold along ([xy])=(\d+)/).map { |(axis, num)| [axis.to_sym, num.to_i] }

first_fold_axis, first_fold_num = folds.first
first_fold = send("fold_#{first_fold_axis}", paper, first_fold_num)
puts first_fold.flatten.count { |dot| dot == '#' }
draw(folds.inject(paper) { |res, (axis, num)| send("fold_#{axis}", res, num) })
