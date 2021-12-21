# frozen_string_literal: true

require_relative 'helper'

starting_positions = input_lines('21').map { |line| line.scan(/Player \d starting position: (\d+)/)[0].first.to_i }

def next_pos(current_pos, roll_total)
  (current_pos + roll_total - 1) % 10 + 1
end

dice_rolls = (1..100).to_a * 100
game_data = { num_of_rolls: 0, current_player: 0, positions: starting_positions.dup, scores: [0, 0] }
dice_rolls.each_slice(3) do |rolls|
  game_data[:num_of_rolls] += 3
  game_data[:positions][game_data[:current_player]] =
    next_pos(game_data[:positions][game_data[:current_player]], rolls.sum)
  game_data[:scores][game_data[:current_player]] += game_data[:positions][game_data[:current_player]]
  break if game_data[:scores][game_data[:current_player]] >= 1000

  game_data[:current_player] = (game_data[:current_player] + 1) % 2
end

puts game_data[:scores].min * game_data[:num_of_rolls]

# ##

def play_rec(p1, p2, s1, s2, cache, roll_freqs)
  return [1, 0] if s1 >= 21
  return [0, 1] if s2 >= 21

  wins = [0, 0]
  cache_key = [p1, p2, s1, s2]
  return cache[cache_key] if cache[cache_key]

  roll_freqs.each do |sum, freq|
    new_p1 = next_pos(p1, sum)
    new_wins = play_rec(p2, new_p1, s2, s1 + new_p1, cache, roll_freqs)
    wins[0] += new_wins[1] * freq
    wins[1] += new_wins[0] * freq
  end

  cache[cache_key] = wins
end

def play(p1, p2, roll_freqs)
  cache = {}
  play_rec(p1, p2, 0, 0, cache, roll_freqs)
  cache[[p1, p2, 0, 0]]
end

rolls = [1, 2, 3]
roll_freqs = rolls.product(rolls, rolls).each_with_object(Hash.new(0)) { |r, res| res[r.sum] += 1 }
puts play(*starting_positions, roll_freqs).max
