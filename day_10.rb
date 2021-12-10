# frozen_string_literal: true

require_relative 'helper'

def check_line(line)
  braces = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
  }

  stack = []

  line.each_char do |c|
    if braces.keys.include?(c)
      stack.push(c)
    elsif c == braces[stack.last]
      stack.pop
    else
      return { corrupt: true, first_corrupt_brace: c }
    end
  end

  { corrupt: false, closing_needed: stack.reverse.map { |c| braces[c] } }
end

corrupt_lines, incomplete_lines = input_lines('10').map { |line| check_line(line) }.partition { |data| data[:corrupt] }

puts corrupt_lines.sum { |data|
  { ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25_137 }[data[:first_corrupt_brace]]
}

puts incomplete_lines.map { |data|
  data[:closing_needed].inject(0) do |sum, c|
    { ')' => 1,
      ']' => 2,
      '}' => 3,
      '>' => 4 }[c] + sum * 5
  end
}.sort[incomplete_lines.count / 2]
