# frozen_string_literal: true

require_relative "common"

historian_computer = Common::HistorianComputer.new
while (line = $stdin.gets)
  line.strip!
  break if line.empty?

  register, value = line.split(": ")
  _, register = register.split
  case register
  when "A"
    historian_computer.a = value.to_i
  when "B"
    historian_computer.b = value.to_i
  when "C"
    historian_computer.c = value.to_i
  end
end

while (line = $stdin.gets)
  line.strip!
  _, instructions = line.split(":")
  historian_computer.instructions = instructions.split(",").map(&:to_i)
end

possible_a = 0o30
copy = nil
loop do
  copy = historian_computer.dup
  copy.a = possible_a
  copy.run_instructions
  if copy.output.size < historian_computer.instructions.size && copy.output == historian_computer.instructions[-copy.output.size..]
    possible_a <<= 6
    next
  end

  break if copy.output == historian_computer.instructions

  possible_a = possible_a.succ
end
pp possible_a
