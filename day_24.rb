# frozen_string_literal: true

require_relative 'helper'

class Monad
  def initialize(instructions)
    @instructions = instructions
  end

  def run(input)
    @pc = 0
    @registers = { w: 0, x: 0, y: 0, z: 0 }
    @input = input
    @ic = 0

    while @pc < @instructions.count
      execute_instruction(@instructions[@pc])
      @pc += 1
    end

    @registers.dup
  end

  private

  def execute_instruction(instruction)
    register = instruction[:lhs][:name]
    rhs_value = case instruction[:rhs][:type]
                when :scalar then instruction[:rhs][:value]
                when :variable then @registers[instruction[:rhs][:name]]
                end

    case instruction[:code]
    when :inp
      @registers[register] = @input[@ic]
      @ic += 1
    when :add
      @registers[register] += rhs_value
    when :mul
      @registers[register] *= rhs_value
    when :div
      @registers[register] /= rhs_value
    when :mod
      @registers[register] %= rhs_value
    when :eql
      @registers[register] = (@registers[register] == rhs_value ? 1 : 0)
    end
  end
end

def parse_arg(arg)
  return { type: :missing } unless arg
  return { type: :variable, name: arg.to_sym } if %w[w x y z].include?(arg)

  { type: :scalar, value: arg.to_i }
end

def parse_program(text)
  text.split(/\n/).map do |line|
    instruction, lhs, rhs = line.split(/\s+/)

    { code: instruction.to_sym, lhs: parse_arg(lhs), rhs: parse_arg(rhs) }
  end
end

alu = Monad.new(parse_program(input('24')))

# conditions to fulfill:
# * i4 = i3 - 2
# * i7 = i6 - 1
# * i9 = i8 - 3
# * i11 = i10 - 7
# * i12 = i5 - 5
# * i13 = i2 + 3
# * i14 = i1 - 4

largest_serial = [9, 6, 9, 7, 9, 9, 8, 9, 6, 9, 2, 4, 9, 5]
puts largest_serial.join if alu.run(largest_serial)[:z].zero?

smallest_serial = [5, 1, 3, 1, 6, 2, 1, 4, 1, 8, 1, 1, 4, 1]
puts smallest_serial.join if alu.run(smallest_serial)[:z].zero?
