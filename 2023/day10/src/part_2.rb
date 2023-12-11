# frozen_string_literal: true

require_relative "common"

nodes = []
idx = 0
while (line = $stdin.gets)
  nodes << Common.read_line(line, north_nodes: nodes[idx - 1])
  start_node ||= nodes.last.find { |v| v&.is_start }
  idx += 1
end

q = Queue.new

nodes.each_with_index do |node_line, idx|
  node_line.each_with_index do |node, jdx|
    q << [node, idx, jdx] if node
  end
end

until q.empty?
  node, idx, jdx = q.pop
  next if node.correctly_connected?

  # puts "removing #{node} for not being correctly_connected"
  node.left&.right = nil
  node.right&.left = nil
  node.up&.down = nil
  node.down&.up = nil
  q << [node.left, idx, jdx - 1] if node.left
  q << [node.right, idx, jdx + 1] if node.right
  q << [node.up, idx - 1, jdx] if node.up
  q << [node.down, idx + 1, jdx] if node.down
  nodes[idx][jdx] = nil
end
start_node.adjust_type!
pp start_node

q = []

# Common.print_current_pos(nodes, -99, -99)

count = 0
idx = 0
nodes.each do |node_line|
  inside = false
  jdx = 0
  node_line.each do |node|
    if node.nil?
      if inside
        puts "(#{idx}, #{jdx})"
        count += 1
      end
    elsif ["|", "F", "7"].include?(node.pipe_type)
      inside = !inside
    end
    jdx += 1
  end
  idx += 1
end
puts count
