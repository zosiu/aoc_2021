# frozen_string_literal: true

def input(day)
  File.read("input/day_#{day}.txt")
end

def input_lines(day)
  input(day).split(/\n/)
end

def input_numbers(day)
  input_lines(day).map(&:to_i)
end
