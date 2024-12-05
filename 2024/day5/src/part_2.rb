# frozen_string_literal: true

require_relative "common"

ordering_rules = Common::OrderRules.new

while (line = $stdin.gets)
  line.strip!
  break if line.empty?

  ordering_rules.add(line)
end

sum = 0
while (line = $stdin.gets)
  line.strip!
  update = line.split(",").map(&:to_i)

  next if Common.valid_update?(update, ordering_rules)

  update = Common.order_update(update, ordering_rules)

  sum += update[(update.size / 2).ceil]
end
pp sum
