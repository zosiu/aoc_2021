# frozen_string_literal: true

require_relative 'helper'

class Num
  attr_reader :value

  def self.zero
    Num.new(0)
  end

  def initialize(value)
    @value = value
  end

  def deep_dup
    Num.new(value)
  end

  def magnitude
    @value
  end

  def add_to_left(other)
    @value += other.value
  end

  def add_to_right(other)
    @value += other.value
  end

  def explode(_curren_depth, _explode_depth); end

  def split
    return if value < 10

    half = value / 2
    Pair.new(Num.new(half), Num.new(value - half))
  end
end

class Pair
  attr_reader :left, :right

  def self.parse(input)
    return Num.new(input) unless input.is_a?(Array)

    lhs, rhs = input
    Pair.new(parse(lhs), parse(rhs))
  end

  def deep_dup
    Pair.new(left.deep_dup, right.deep_dup)
  end

  def initialize(left, right)
    @left = left
    @right = right
  end

  def magnitude
    3 * left.magnitude + 2 * right.magnitude
  end

  def +(other)
    Pair.new(self, other).deep_dup.reduce
  end

  def reduce
    tap { loop { explode(1, 4) || split ? next : break } }
  end

  def split
    if (left_split = left.split)
      tap { @left = left_split }
    elsif (right_split = right.split)
      tap { @right = right_split }
    end
  end

  def explode(current_depth, explode_depth)
    return self if current_depth > explode_depth

    if (res = left.explode(current_depth + 1, explode_depth))
      @left = Num.zero if current_depth == explode_depth
      @right.add_to_left(res.right)
      Pair.new(res.left, Num.zero)
    elsif (res = right.explode(current_depth + 1, explode_depth))
      @left.add_to_right(res.left)
      @right = Num.zero if current_depth == explode_depth
      Pair.new(Num.zero, res.right)
    end
  end

  def add_to_left(node)
    left.add_to_left(node)
  end

  def add_to_right(node)
    right.add_to_right(node)
  end
end

# ---

input = input_lines('18')
nums = input.map { |line| Pair.parse(eval(line)) }
puts nums[1..-1].clone.inject(nums.first.clone, :+).magnitude

puts nums.combination(2).map { |(x, y)| [x + y, y + x].map(&:magnitude) }.flatten.max
