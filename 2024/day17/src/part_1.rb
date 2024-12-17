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

historian_computer.run_instructions

pp historian_computer.output.join(",")
