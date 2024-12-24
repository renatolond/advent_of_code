# frozen_string_literal: true

require_relative "common"

gates = {}
zgates = []
while (line = $stdin.gets)
  line.strip!
  break if line.empty?

  name, value = line.split(": ")
  gates[name] = Common::Gate.new(name)
  gates[name].result = value.to_i
  zgates << name if name.start_with?("z")
end

while (line = $stdin.gets)
  line.strip!
  break if line.empty?

  parents, name = line.split(" -> ")
  parent1, type, parent2 = parents.split
  gates[name] = Common::Gate.new(name, type: type.downcase.to_sym, parent1:, parent2:)
  zgates << name if name.start_with?("z")
end

Common.gates = gates

result = 0
zgates.sort.reverse_each do |gate_name|
  result <<= 1
  result += gates[gate_name].result
end

pp result
