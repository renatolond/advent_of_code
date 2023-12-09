# frozen_string_literal: true

require_relative "common"

path = $stdin.gets.strip

$stdin.gets # throw away empty line

nodes = {}
while (line = $stdin.gets)
  node = Common.read_node(line)
  nodes[node.name] = node
end

current_node = nodes["AAA"]
idx = 0
steps = 0
while current_node.name != "ZZZ"
  # puts "idx: #{idx} & path #{path[idx]}"
  current_node = case path[idx]
                 when "L"
                   nodes[current_node.left]
                 else
                   nodes[current_node.right]
  end
  # puts "walked to #{current_node.name}"

  idx += 1
  steps += 1
  idx = 0 if idx >= path.size
end
puts steps
