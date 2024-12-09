# frozen_string_literal: true

require_relative "common"

file = true
disk = Common::Disk.new
while (char = $stdin.getc)
  begin
    number = Integer(char)
  rescue
    break
  end

  if file
    disk.add_file(number)
    file = false
  else
    disk.add_space(number)
    file = true
  end
end

pp disk.full_file_defrag_and_sum
