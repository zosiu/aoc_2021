# frozen_string_literal: true

require_relative 'helper'

timers = input('06').split(/\s*,\s*/).each_with_object(Hash.new(0)) { |t, res| res[t.to_i] += 1 }

256.times do |day|
  dead = timers[0]
  timers[0] = timers[1]
  timers[1] = timers[2]
  timers[2] = timers[3]
  timers[3] = timers[4]
  timers[4] = timers[5]
  timers[5] = timers[6]
  timers[6] = timers[7] + dead
  timers[7] = timers[8]
  timers[8] = dead

  puts timers.to_a.sum(&:last) if day == 79
end

puts timers.to_a.sum(&:last)
