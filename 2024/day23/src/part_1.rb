# frozen_string_literal: true

require_relative "common"

graph = {}
t_nodes = Set.new
while (line = $stdin.gets)
  line.strip!
  node1, node2 = line.split("-")
  graph[node1] ||= Common::Node.new(node1)
  graph[node2] ||= Common::Node.new(node2)
  graph[node1].pointers << graph[node2]
  graph[node2].pointers << graph[node1]
  t_nodes << graph[node1] if node1.start_with?("t")
  t_nodes << graph[node2] if node2.start_with?("t")
end
cycles = Set.new
t_nodes.each do |v|
  cycles += Common.cycle_detector(v.name, graph)
end
cycles.select! { |c| c.size == 3 }
pp cycles
