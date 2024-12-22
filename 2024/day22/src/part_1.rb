# frozen_string_literal: true

require_relative "common"

sum = 0
while (line = $stdin.gets)
  line.strip!
  secret = Common::SecretNumber.new(line.to_i)
  2000.times do
    secret.next
  end
  puts "#{line}: #{secret.current}"
  sum += secret.current
end
pp sum
