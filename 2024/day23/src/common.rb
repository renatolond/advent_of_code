# frozen_string_literal: true

module Common
  class Node
    def initialize(name)
      @name = name
      @pointers = Set.new
      @visited = false
    end

    attr_accessor :pointers, :visited
    attr_reader :name

    def inspect
      "#<#{self.class.name} @name=#{@name.inspect}>"
    end

    def ==(other)
      other.class == self.class &&
        name == other.name
    end
  end
  class << self
    # @param start_node [String]
    # @param graph [Hash{String=>Node}]
    # @param max_cost [Integer]
    def cycle_detector(start_node, graph, max_cost: 3)
      queue = []

      visited = Hash.new { |h, k| h[k] = Float::INFINITY }

      cycles = []
      visited_points = []
      queue << [graph[start_node], 0, visited_points]
      while (curr_node = queue.shift)
        curr_node, current_cost, current_path = curr_node
        next if current_cost > max_cost

        if current_cost == max_cost && curr_node.name == start_node
          cycles << current_path.sort_by(&:name)
          next
        end
        visited[curr_node.name] = current_cost

        curr_node.pointers.each do |p|
          queue << [p, current_cost + 1, (current_path.dup << curr_node)]
        end
      end

      cycles
    end

    # @param start_node [String]
    # @param graph [Hash{String=>Node}]
    def clique_detector(start_node, graph)
      cliques = Set.new
      graph[start_node].pointers.each do |p|
        clique = [graph[start_node], p].to_set
        visited = Hash.new { |h, k| h[k] = false }
        visited[start_node] = true

        queue = graph[start_node].pointers.to_a.sort_by { |v| -v.pointers.size }

        while (curr_node = queue.pop)
          is_in_clique = true
          visited[curr_node.name] = true
          clique.each do |c|
            next if curr_node.pointers.include?(c)

            is_in_clique = false
            break
          end

          next unless is_in_clique

          clique << curr_node

          curr_node.pointers.to_a.sort_by { |v| -v.pointers.size }.each do |p|
            next if visited[p.name]

            queue << p
          end
        end

        cliques << clique.sort_by(&:name)
      end
      cliques
    end
  end
end
