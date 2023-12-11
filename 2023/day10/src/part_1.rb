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
pp start_node
nodes.each do |node_line|
  puts node_line.map { |v| v ? v.pipe_type : "." }.join
end
# pp nodes

q = Queue.new
q << [start_node, 0]
visited_nodes = Set.new
max_distance = -1
until q.empty?
  node, distance = q.pop
  max_distance = distance if distance > max_distance
  visited_nodes << node
  distance += 1
  q << [node.left, distance] if node.left && !visited_nodes.include?(node.left)
  q << [node.right, distance] if node.right && !visited_nodes.include?(node.right)
  q << [node.up, distance] if node.up && !visited_nodes.include?(node.up)
  q << [node.down, distance] if node.down && !visited_nodes.include?(node.down)
end
pp max_distance
