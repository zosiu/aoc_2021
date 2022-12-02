# frozen_string_literal: true

require_relative 'helper'

signals = input_lines('08').map do |l|
  x, y = l.split(/\s*\|\s*/)
  { signal_pattern: x.strip.split.map(&:chars).map(&:sort),
    four_digit_value: y.strip.split.map(&:chars).map(&:sort) }
end

digit_table = {
  %w[c f] => 1,
  %w[a c f] => 7,
  %w[b c d f] => 4,
  %w[a c d e g] => 2,
  %w[a c d f g] => 3,
  %w[a b d f g] => 5,
  %w[a b c e f g] => 0,
  %w[a b d e f g] => 6,
  %w[a b c d f g] => 9,
  %w[a b c d e f g] => 8
}

def signal_mapping(pattern)
  cf = pattern.find { |p| p.count == 2 }
  acf = pattern.find { |p| p.count == 3 }
  bcdf = pattern.find { |p| p.count == 4 }
  a = acf - cf
  bd = bcdf - cf

  be = pattern.select do |p|
         p.count == 5
       end.flatten.each_with_object(Hash.new(0)) { |c, r| r[c] += 1 }.select { |_k, v| v == 1 }.map(&:first)

  b = be & bd
  e = be - b
  d = bd - b

  abcdf = pattern.select { |p| [2, 3, 4].any? { |c| p.count == c } }.flatten.uniq
  g = pattern.find { |p| p.count == 7 } - abcdf - e

  ecd = pattern.select do |p|
          p.count == 6
        end.flatten.each_with_object(Hash.new(0)) { |c, r| r[c] += 1 }.select { |_k, v| v == 2 }.map(&:first)
  c = ecd - e - d
  f = cf - c

  {
    a.first => 'a',
    b.first => 'b',
    c.first => 'c',
    d.first => 'd',
    e.first => 'e',
    f.first => 'f',
    g.first => 'g'
  }
end

puts signals.sum { |data|
  data[:four_digit_value].count do |p|
    digit_table.invert.slice(1, 4, 7, 8).values.map(&:count).include?(p.count)
  end
}

puts signals.sum { |data|
  mapping = signal_mapping(data[:signal_pattern])
  data[:four_digit_value].map { |code| digit_table[code.map { |s| mapping[s] }.sort] }.join.to_i
}
