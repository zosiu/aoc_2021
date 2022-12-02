# frozen_string_literal: true

require_relative 'helper'
require 'strscan'

binary_input = input('16').chars.map do |c|
  { '0' => '0000',
    '1' => '0001',
    '2' => '0010',
    '3' => '0011',
    '4' => '0100',
    '5' => '0101',
    '6' => '0110',
    '7' => '0111',
    '8' => '1000',
    '9' => '1001',
    'A' => '1010',
    'B' => '1011',
    'C' => '1100',
    'D' => '1101',
    'E' => '1110',
    'F' => '1111' }[c]
end.join

def bits(n, start = '[01]')
  Regexp.new(start + '[01]' * (n - 1))
end

def parse_next(buffer, n)
  packets = []
  while packets.count < n
    version = buffer.scan(bits(3)).to_i(2)
    code = buffer.scan(bits(3)).to_i(2)
    if code == 4
      value_reg = Regexp.new("#{bits(5, '1')}*#{bits(5, '0')}")
      packets << {
        version: version,
        code: code,
        value: buffer.scan_until(value_reg).chars.each_with_index.reject do |_, i|
                 (i % 5).zero?
               end.map(&:first).join.to_i(2)
      }
    else
      op_type = buffer.scan(bits(1))
      case op_type
      when '0'
        len = buffer.scan(bits(15)).to_i(2)
        packets << { version: version, code: code,
                     sub_packets: parse_next(StringScanner.new(buffer.scan(bits(len))), Float::INFINITY) }
      when '1'
        num = buffer.scan(bits(11)).to_i(2)
        packets << { version: version, code: code, sub_packets: parse_next(buffer, num) }
      end
    end

    break if buffer.eos?
  end

  packets
end

def version_sum(packet)
  return packet[:version] unless packet[:sub_packets]

  packet[:version] + packet[:sub_packets].sum { |sp| version_sum(sp) }
end

def evaluate(packet)
  case packet[:code]
  when 4 then packet[:value]
  when 0 then packet[:sub_packets].inject(0) { |sum, sp| sum + evaluate(sp) }
  when 1 then packet[:sub_packets].inject(1) { |prod, sp| prod * evaluate(sp) }
  when 2 then packet[:sub_packets].map { |sp| evaluate(sp) }.min
  when 3 then packet[:sub_packets].map { |sp| evaluate(sp) }.max
  when 5
    lhs, rhs = packet[:sub_packets].map { |sp| evaluate(sp) }
    lhs > rhs ? 1 : 0
  when 6
    lhs, rhs = packet[:sub_packets].map { |sp| evaluate(sp) }
    lhs < rhs ? 1 : 0
  when 7
    lhs, rhs = packet[:sub_packets].map { |sp| evaluate(sp) }
    lhs == rhs ? 1 : 0
  end
end

packet = parse_next(StringScanner.new(binary_input), 1).first
puts version_sum(packet)
puts evaluate(packet)
