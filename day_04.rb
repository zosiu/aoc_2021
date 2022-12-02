# frozen_string_literal: true

require_relative 'helper'

def bingo?(board)
  any_complete_row = board.any? { |line| line.all? { |line_data| line_data[:seen] } }
  any_complete_column = (0...board.size).any? do |i|
    board.map { |line| line[i] }.all? { |line_data| line_data[:seen] }
  end

  any_complete_row || any_complete_column
end

def score(board)
  board.flatten.reject { |line_data| line_data[:seen] }.sum { |line_data| line_data[:num] }
end

nums_input, *boards_input = input('04').split("\n")
nums = nums_input.split(/\s*,\s*/).map(&:to_i)
boards = boards_input.reject!(&:empty?).each_slice(5).map do |s|
  s.each.map { |l| l.split.map { |d| { num: d.to_i, seen: false } } }
end

bingo_data = nums.each_with_object([]) do |num, bingos|
  boards.each do |board|
    board.each do |line|
      line.each do |line_data|
        line_data[:seen] = true if line_data[:num] == num
      end
    end

    bingos << { board: board, num: num } if bingo?(board)
  end

  bingos.each do |bingo|
    boards.delete(bingo[:board])
  end
end

first_bingo = bingo_data.first
puts first_bingo[:num] * score(first_bingo[:board])

last_bingo = bingo_data.last
puts last_bingo[:num] * score(last_bingo[:board])
