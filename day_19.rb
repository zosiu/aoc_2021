# frozen_string_literal: true

require_relative 'helper'

scanner_data = input('19').split(/\n\n/).map do |chunk|
  _, *data = chunk.split(/\n/)
  data.map { |line| line.split(/\s*,\s*/).map(&:to_i) }
end

def possible_vector(vector, id)
  x, y, z = vector
  [[x, y, z], [y, z, x], [z, x, y], [-x, z, y],
   [z, y, -x], [y, -x, z], [x, z, -y], [z, -y, x],
   [-y, x, z], [x, -z, y], [-z, y, x], [y, x, -z],
   [-x, -y, z], [-y, z, -x], [z, -x, -y], [-x, y, -z],
   [y, -z, -x], [-z, -x, y], [x, -y, -z], [-y, -z, x],
   [-z, x, -y], [-x, -z, -y], [-z, -y, -x], [-y, -x, -z]][id]
end

beacons = [[0, 0, 0]] + [nil] * (scanner_data.count - 1)

while beacons.any?(&:nil?)
  unknown, known = beacons.each_with_index.partition { |beacon, _i| beacon.nil? }
  unknown_indices = unknown.map(&:last)
  known_indices = known.map(&:last)

  beacon_coord = nil
  unknown_index = nil
  known_index = nil

  unknown_indices.each do |unknown_i|
    known_indices.each do |known_i|
      beacon_coord = scanner_data[unknown_i].each_with_object(Hash.new(0)) do |coords, dists|
        24.times do |transform_id|
          x1, y1, z1 = possible_vector(coords, transform_id)

          scanner_data[known_i].each do |(x2, y2, z2)|
            dists[[x2 - x1, y2 - y1, z2 - z1]] += 1
          end
        end
      end.select { |_k, v| v >= 12 }.map(&:first).first

      next unless beacon_coord

      known_index = known_i
      unknown_index = unknown_i
      break
    end
    break if beacon_coord
  end

  x1, y1, z1 = beacon_coord
  tid = 24.times.select do |transform_id|
    (scanner_data[unknown_index].map do |coord|
      x2, y2, z2 = possible_vector(coord, transform_id)
      [x1 + x2, y1 + y2, z1 + z2]
    end & scanner_data[known_index]).count >= 12
  end.first

  beacons[unknown_index] = beacon_coord
  scanner_data[unknown_index].map! do |coord|
    x2, y2, z2 = possible_vector(coord, tid)
    [x1 + x2, y1 + y2, z1 + z2]
  end
end

puts scanner_data.flatten(1).uniq.count
puts beacons.combination(2).map { |(bx1, by1, bz1), (bx2, by2, bz2)|
  (bx1 - bx2).abs + (by1 - by2).abs + (bz1 - bz2).abs
}.max
