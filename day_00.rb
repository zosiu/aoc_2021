# frozen_string_literal: true

require_relative 'helper'

puts input_numbers('00').sum
puts input_numbers('00').filter(&:even?).sum
