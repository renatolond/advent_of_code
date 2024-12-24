# frozen_string_literal: true

require_relative "common"

gates = {}
zgates = []
xgates = []
ygates = []
while (line = $stdin.gets)
  line.strip!
  break if line.empty?

  name, value = line.split(": ")
  gates[name] = Common::Gate.new(name)
  gates[name].result = value.to_i
  xgates << name if name.start_with?("x")
  ygates << name if name.start_with?("y")
  zgates << name if name.start_with?("z")
end

while (line = $stdin.gets)
  line.strip!
  break if line.empty?

  parents, name = line.split(" -> ")
  parent1, type, parent2 = parents.split
  gates[name] = Common::Gate.new(name, type: type.downcase.to_sym, parent1:, parent2:)
  xgates << name if name.start_with?("x")
  ygates << name if name.start_with?("y")
  zgates << name if name.start_with?("z")
end

xgates.sort!
ygates.sort!
zgates.sort!

Common.gates = gates

xnumber = 0
xgates.reverse_each do |gate_name|
  xnumber <<= 1
  xnumber += gates[gate_name].result
end
ynumber = 0
ygates.reverse_each do |gate_name|
  ynumber <<= 1
  ynumber += gates[gate_name].result
end

test_cases = [
  [xnumber, ynumber, xnumber + ynumber],
  [17_592_186_044_416, 17_592_186_044_416, 35_184_372_088_832],
  [35_184_372_088_831, 35_184_372_088_830, 70_368_744_177_661],
  [35_184_372_088_831, 35_184_372_088_831, 70_368_744_177_662],
  [0, 32, 32],
  [1, 2, 3],
  [1, 1, 2],
  [2, 1, 3],
  [0, 1, 1],
  [1, 0, 1]
]

# 35_184_372_088_831.times do |n1|
#   35_184_372_088_831.times do |n2|
#     expected_result = n1 + n2
#   orig_n1 = n1
#   orig_n2 = n2
test_cases.each do |n1, n2, expected_result|
  Common.reset_gates!
  orig_n1 = n2
  orig_n2 = n2
  xgates.each do |gate_name|
    gates[gate_name].result = n1 % 2
    n1 >>= 1
  end

  ygates.each do |gate_name|
    gates[gate_name].result = n2 % 2
    n2 >>= 1
  end

  result = 0
  zgates.reverse_each do |gate_name|
    result <<= 1
    result += gates[gate_name].result
  end

  next if result == expected_result
  pp orig_n1
  pp orig_n2
  pp result
  pp expected_result
  puts(format("%46s <-- result", result.to_s(2)))
  puts(format("%46s", expected_result.to_s(2)))
  puts "============================="
end
#  end
