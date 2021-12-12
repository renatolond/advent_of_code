# TODO: Write documentation for `Day9`
module Day12
  VERSION = "0.1.0"

  class CaveGraph
    @single_visit_nodes = Set(String).new()
    @paths = Set(Array(String)).new()
    @graph = {} of String => Set(String)
    @visited = Set(String).new()
    @visit_caves_twice = false

    def initialize(visit_caves_twice = false)
      @visit_caves_twice = visit_caves_twice
    end

    def add_link(link)
      a, b = link.split("-")
      @single_visit_nodes << a if a == a.downcase
      @single_visit_nodes << b if b == b.downcase
      @graph[a] ||= Set(String).new
      @graph[b] ||= Set(String).new
      @graph[a] << b
      @graph[b] << a
    end

    def paths
      @paths.map { |v| v.join(",") }.sort
    end

    def num_paths
      paths.size
    end

    START_NODE = "start"
    END_NODE = "end"
    def find_paths
      small_caves_to_revisit = if @visit_caves_twice
                                 1
                               else
                                 0
                               end
      visit(START_NODE, [] of String, small_caves_to_revisit)
    end

    def visit(node, current_path, small_caves_to_revisit)
      return if @single_visit_nodes.includes?(node) &&
                @visited.includes?(node) &&
                (small_caves_to_revisit == 0 || node == START_NODE || node == END_NODE)
      # Loop detection [a,b,a,b,a,b]
      if current_path.size >= 5 && node == current_path[-2] && node == current_path[-4] && current_path[-1] == current_path[-3] && current_path[-3] == current_path[-5]
        puts "seems like a loop, exiting"
        return
      end

      should_unvisit = true

      if @single_visit_nodes.includes?(node) &&
         @visited.includes?(node)
        small_caves_to_revisit = 0
        should_unvisit = false
      end

      begin
        @visited << node
        current_path << node

        if node == END_NODE
          @paths << current_path.dup
          return
        end

        @graph[node].each do |n|
          visit(n, current_path, small_caves_to_revisit)
        end
      ensure
        current_path.pop
        @visited.delete(node) if should_unvisit
      end
    end
  end

  def self.part_1()
    cg = CaveGraph.new
    while (line = gets())
      cg.add_link(line)
    end
    cg.find_paths

    puts cg.num_paths
  end

  def self.part_2()
    cg = CaveGraph.new(true)
    while (line = gets())
      cg.add_link(line)
    end
    cg.find_paths

    puts cg.num_paths
  end
end
