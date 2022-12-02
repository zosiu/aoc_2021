# frozen_string_literal: true

require_relative 'helper'

$corridors = [0, 1, 3, 5, 7, 9, 10]
$rooms = [2, 4, 6, 8]
$room_depth = 4
$room_assignments = {
  2 => 'A',
  4 => 'B',
  6 => 'C',
  8 => 'D'
}

$starting_layout = {
  [0, 0] => '.',
  [1, 0] => '.',
  [3, 0] => '.',
  [5, 0] => '.',
  [7, 0] => '.',
  [9, 0] => '.',
  [10, 0] => '.',

  [2, 1] => 'A',
  [2, 2] => 'D',
  [2, 3] => 'D',
  [2, 4] => 'C',

  [4, 1] => 'D',
  [4, 2] => 'C',
  [4, 3] => 'B',
  [4, 4] => 'D',

  [6, 1] => 'C',
  [6, 2] => 'B',
  [6, 3] => 'A',
  [6, 4] => 'B',

  [8, 1] => 'A',
  [8, 2] => 'A',
  [8, 3] => 'C',
  [8, 4] => 'B'
}

$desired_layout = {
  [0, 0] => '.',
  [1, 0] => '.',
  [3, 0] => '.',
  [5, 0] => '.',
  [7, 0] => '.',
  [9, 0] => '.',
  [10, 0] => '.',

  [2, 1] => 'A',
  [2, 2] => 'A',
  [2, 3] => 'A',
  [2, 4] => 'A',

  [4, 1] => 'B',
  [4, 2] => 'B',
  [4, 3] => 'B',
  [4, 4] => 'B',

  [6, 1] => 'C',
  [6, 2] => 'C',
  [6, 3] => 'C',
  [6, 4] => 'C',

  [8, 1] => 'D',
  [8, 2] => 'D',
  [8, 3] => 'D',
  [8, 4] => 'D'
}

def to_key(layout)
  ($corridors.map { [_1, 0] } + $rooms.flat_map do |r|
                                  1.upto($room_depth).map do
                                    [r, _1]
                                  end
                                end).map { layout[_1] }.join
end

def from_key(key)
  corridors, rooms = key.chars.each_with_index.partition { |_, i| i < $corridors.count }
  res = {}
  corridors.map(&:first).each_with_index { |c, i| res[[$corridors[i], 0]] = c }
  rooms.map(&:first).each_slice($room_depth).each_with_index do |s, i|
    s.each_with_index do |c, d|
      res[[$rooms[i], d + 1]] = c
    end
  end
  res
end

def corridor?(pos)
  $corridors.include?(pos.first)
end

def room?(pos)
  $rooms.include?(pos.first)
end

def first_in_room?(pos, layout)
  i, d = pos
  room?(pos) && (1...d).all? { layout[[i, _1]] == '.' }
end

def first_in_room_nonempty?(pos, layout)
  layout[pos] != '.' &&
    first_in_room?(pos, layout)
end

def final_place_in_room?(pos, layout)
  i, d = pos
  letter = layout[pos]
  room?(pos) && $room_assignments[i] == letter && $room_depth.downto(d).all? { layout[[i, _1]] == letter }
end

def final_place_in_room_nonempty?(pos, layout)
  layout[pos] != '.' && final_place_in_room?(pos, layout)
end

def valid_moves(from, layout)
  return [] if layout[from] == '.'

  i, d = from

  if room?(from)
    return [] if final_place_in_room_nonempty?(from, layout)
    return [] unless first_in_room_nonempty?(from, layout)

    $corridors.select do |c|
      start, finish = [c, i].minmax
      $corridors.select { |cb| cb.between?(start, finish) }.all? { layout[[_1, 0]] == '.' }
    end.map { [_1, 0] }
  elsif corridor?(from)
    ri = $room_assignments.keys.detect { $room_assignments[_1] == layout[from] }
    rd = $room_depth.downto(d).detect { layout[[ri, _1]] == '.' }
    return [] unless rd
    return [] if $room_depth.downto(rd + 1).any? { layout[[ri, _1]] != layout[from] }

    start, finish = [i, ri].minmax
    corridors_in_between = $corridors.select { |cb| cb < finish && cb > start }
    return [] unless corridors_in_between.all? { layout[[_1, 0]] == '.' }

    [[ri, rd]]
  end
end

def cost(from_corridor, to_room, layout)
  return cost(to_room, from_corridor, layout) if room?(from_corridor)

  start, finish = [to_room.first, from_corridor.first].minmax
  steps = ($rooms + $corridors).count { _1.between?(start, finish) } + to_room.last - 1
  letter = layout[to_room] == '.' ? layout[from_corridor] : layout[to_room]
  steps * case letter
          when 'A' then 1
          when 'B' then 10
          when 'C' then 100
          when 'D' then 1000
          end
end

def possible_moves(layout)
  layout.keys.flat_map { |from| valid_moves(from, layout).map { |to| [from, to] } }
end

# ---

min_costs = Hash.new { |hsh, k| hsh[k] = { cost: Float::INFINITY, prev: nil } }
min_costs[to_key($starting_layout)] = { cost: 0, prev: nil }
stack = [to_key($starting_layout)]

until stack.empty?
  current_key = stack.pop
  current_cost = min_costs[current_key][:cost]
  current_state = from_key(current_key)

  # break if current_key == to_key($desired_layout) && min_costs[current_key][:cost] <= 52_055

  possible_moves(current_state).each do |(from, to)|
    next_state = from_key(current_key)
    next_state[to] = next_state[from]
    next_state[from] = '.'
    total_cost = current_cost + cost(from, to, current_state)
    next_key = to_key(next_state)

    next unless min_costs[next_key][:cost] > total_cost

    min_costs[next_key][:cost] = total_cost
    min_costs[next_key][:prev] = current_key

    stack << next_key unless stack.include?(next_key)
  end
end

res = min_costs[to_key($desired_layout)]
pp res[:cost]
# prev = res[:prev]
# while prev
#   pp prev
#   prev = min_costs[prev][:prev]
# end
