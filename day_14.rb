# frozen_string_literal: true

require_relative 'helper'

poly, rules = input('14').split(/\n\n/)
rules = rules.split(/\n/).map do |line|
  fl, m = line.scan(/(..) -> (.)/).flatten
  f, l = fl.chars
  [[f, l], { pairs: [[f, m], [m, l]], middle: m }]
end.to_h

single_counts = poly.chars.each_with_object(Hash.new(0)) { |p, res| res[p] += 1 }
pair_counts = poly.chars.each_cons(2).each_with_object(Hash.new(0)) { |p, res| res[p] += 1 }

def iterate(single_counts, pair_counts, rules)
  new_pair_counts = Hash.new(0)
  pair_counts.each do |k, v|
    rules[k][:pairs].each { |nk| new_pair_counts[nk] += v }
    single_counts[rules[k][:middle]] += v
    pair_counts[k] = 0
  end
  new_pair_counts.each { |k, v| pair_counts[k] += v }
end

def result(single_counts)
  min, max = single_counts.values.minmax
  max - min
end

40.times do |n|
  iterate(single_counts, pair_counts, rules)
  puts result(single_counts) if n == 9
end

puts result(single_counts)
