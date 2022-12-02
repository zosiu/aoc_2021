# frozen_string_literal: true

require_relative 'helper'

levels = input_numbers('01')

part_one = levels.each_cons(2).count { |n1, n2| n2 > n1 }
puts part_one

part_two = levels.each_cons(4).count { |n1, _, _, n4| n4 > n1 }
puts part_two
