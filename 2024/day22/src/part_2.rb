# frozen_string_literal: true

require_relative "common"

monkeys = []
while (line = $stdin.gets)
  sequences = Hash.new { |h, k| h[k] = Set.new }
  seen_sequences = Set.new
  curr_sequence = []
  line.strip!
  secret = Common::SecretNumber.new(line.to_i)
  prev_secret_digit = secret.current % 10
  2000.times do
    curr_secret_digit = (secret.next % 10)
    curr_sequence << (curr_secret_digit - prev_secret_digit)
    curr_sequence.shift if curr_sequence.size > 4
    prev_secret_digit = curr_secret_digit

    if curr_sequence.size == 4 && !seen_sequences.include?(curr_sequence)
      sequences[curr_secret_digit] << curr_sequence.dup
      seen_sequences << curr_sequence
    end
  end
  monkeys << sequences
end

Common.count_bananas(monkeys)
