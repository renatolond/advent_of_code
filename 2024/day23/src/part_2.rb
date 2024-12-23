# frozen_string_literal: true

require_relative "common"

graph = {}
t_nodes = Set.new
max_pointer_size = 0
while (line = $stdin.gets)
  line.strip!
  node1, node2 = line.split("-")
  graph[node1] ||= Common::Node.new(node1)
  graph[node2] ||= Common::Node.new(node2)
  graph[node1].pointers << graph[node2]
  max_pointer_size = graph[node1].pointers.size if graph[node1].pointers.size > max_pointer_size
  graph[node2].pointers << graph[node1]
  max_pointer_size = graph[node2].pointers.size if graph[node2].pointers.size > max_pointer_size
  t_nodes << graph[node1] if node1.start_with?("t")
  t_nodes << graph[node2] if node2.start_with?("t")
end
cliques = Set.new
graph.each_key do |v|
  new_cliques = Common.clique_detector(v, graph)
  new_cliques.each { |c| cliques << c }
end
pp cliques.max_by(&:size).map(&:name).join(",")
