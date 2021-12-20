# TODO: Write documentation for `Day9`
module Day18
  VERSION = "0.1.0"

  class SnailfishNumber
    @left : Int64 | SnailfishNumber
    @right : Int64 | SnailfishNumber
    @parent : SnailfishNumber?

    getter left, right, parent
    setter parent

    def initialize(left : Int64 | SnailfishNumber, right : Int64 | SnailfishNumber, parent : SnailfishNumber? = nil)
      @left = left
      @right = right
      @parent = parent
      if left.is_a? SnailfishNumber
        left.parent = self
      end
      if right.is_a? SnailfishNumber
        right.parent = self
      end
    end

    def left=(left : Int64)
      @left = left
    end

    def left=(left : SnailfishNumber)
      left.parent = self
      @left = left
    end

    def right=(right : Int64)
      @right = right
    end

    def right=(right : SnailfishNumber)
      right.parent = self
      @right = right
    end

    def +(other : self) : self
      SnailfishNumber.new(self, other).reduce
    end

    def inspect
      "[#{left.inspect},#{right.inspect}]"
    end

    def ==(other : self)
      @left == other.left &&
        @right == other.right
    end

    def reduce : self
      SnailfishNumber.reduce(self)
    end

    def has_more_levels?
      left.is_a? SnailfishNumber || right.is_a? SnailfishNumber
    end

    def self.rightmost_sum(starting_node : SnailfishNumber, left : Int64)
      # traverse the graph to add the left number
      current_node : SnailfishNumber = starting_node
      reached_the_top = false
      # going up
      while true
        prev_node = current_node
        unless (parent = current_node.parent)
          reached_the_top = true
          break
        end
        current_node = parent

        if (l = current_node.left).is_a?(SnailfishNumber) && !prev_node.same?(l)
          current_node = l
          break
        elsif (l = current_node.left).is_a?(Int64)
          current_node.left = l + left
          return
        end
      end

      unless reached_the_top
        # going down to the right
        while true
          if (r = current_node.right).is_a?(SnailfishNumber)
            current_node = r
          else
            break
          end
        end
        if (r = current_node.right).is_a?(Int64)
          current_node.right = r + left
          return
        end
      end
    end

    def self.leftmost_sum(starting_node : SnailfishNumber, right : Int64)
      # traverse the graph to add the right number
      current_node : SnailfishNumber = starting_node
      reached_the_top = false
      # going up
      while true
        prev_node = current_node
        unless (parent = current_node.parent)
          reached_the_top = true
          break
        end
        current_node = parent

        if (r = current_node.right).is_a?(SnailfishNumber) && !prev_node.same?(r)
          current_node = r
          break
        elsif (r = current_node.right).is_a?(Int64)
          current_node.right = r + right
          return
        end
      end

      unless reached_the_top
        # going down to the right
        while true
          if (l = current_node.left).is_a?(SnailfishNumber)
            current_node = l
          else
            break
          end
        end
        if (l = current_node.left).is_a?(Int64)
          current_node.left = l + right
          return
        end
      end
    end

    def self.explode(starting_node : SnailfishNumber, left : Int64, right : Int64)
      rightmost_sum(starting_node, left)
      leftmost_sum(starting_node, right)
    end

    def self.check_and_explode(number)
      current_node : SnailfishNumber = number
      node_queue = [] of Tuple(SnailfishNumber, Int64)
      depth = 1_i64
      idx = 0
      while true
        if current_node.has_more_levels?
          if (r = current_node.right).is_a? SnailfishNumber
            node_queue.push({r, depth + 1})
          end
          if (l = current_node.left).is_a? SnailfishNumber
            node_queue.push({l, depth + 1})
          end
        else
          # Got to the leaf, see if needs to explode
          if depth > 4
            l = current_node.left
            r = current_node.right
            raise "oh noes" if l.is_a?(SnailfishNumber) || r.is_a?(SnailfishNumber)
            self.explode(current_node, l, r)
            parent_node = current_node.parent
            raise "oh noes" if parent_node.nil?
            if parent_node.left == current_node
              parent_node.left = 0
            elsif parent_node.right == current_node
              parent_node.right = 0
            end
          end
        end
        break if node_queue.empty?
        current_node, depth = node_queue.pop
      end
    end

    def self.check_and_split(current_node) : Bool
      if (l = current_node.left).is_a?(Int64)
        if l > 9
          current_node.left = SnailfishNumber.new((l / 2).floor.to_i64, (l / 2).ceil.to_i64)
          return true
        end
      else
        split = check_and_split(l)
        return true if split
      end
      if (r = current_node.right).is_a?(Int64)
        if r > 9
          current_node.right = SnailfishNumber.new((r / 2).floor.to_i64, (r / 2).ceil.to_i64)
          return true
        end
      else
        split = check_and_split(r)
        return true if split
      end
      false
    end

    def self.reduce(number : SnailfishNumber) : SnailfishNumber
      loop do
        check_and_explode(number)
        unless check_and_split(number)
          break
        end
      end

      number
    end

    def magnitude
      l = @left
      case l
      when Int64
        # no op
      when SnailfishNumber
        l = l.magnitude
      end

      r = @right
      case r
      when Int64
        # no op
      when SnailfishNumber
        r = r.magnitude
      end

      3 * l + 2 * r
    end

    def self.read(line)
      read = [] of SnailfishNumber | Int64
      buffer = ""
      line.chars.each do |c|
        if c == ']' || c == ','
          if buffer != ""
            read << buffer.to_i64
            buffer = ""
          end
        end

        if c == ']'
          n2 = read.pop
          n1 = read.pop
          read << SnailfishNumber.new(n1, n2)
        elsif c != '[' && c != ','
          buffer = "#{buffer}#{c}"
        end
      end
      raise "oh noes" if read.size != 1
      ret = read.pop
      raise "oh noes" unless ret.is_a? SnailfishNumber
      ret
    end
  end

  def self.part_1()
    current_snailfish = nil
    while (line = gets())
      to_add = Day18::SnailfishNumber.read(line)
      if current_snailfish
        current_snailfish = current_snailfish + to_add
      else
        current_snailfish = to_add
      end
    end

    raise "oh noes" if current_snailfish.nil?
    puts current_snailfish.inspect
    puts current_snailfish.magnitude
  end

  def self.part_2()
    all_snailfish = [] of String
    current_snailfish = nil
    while (line = gets())
      all_snailfish << line
    end
    bigger_magnitude = -999
    all_snailfish.each_repeated_permutation(2) do |perm|
      a, b = perm
      next if a == b
      a = Day18::SnailfishNumber.read(a)
      b = Day18::SnailfishNumber.read(b)
      magnitude = (a + b).magnitude
      bigger_magnitude = magnitude if magnitude > bigger_magnitude
    end

    puts bigger_magnitude
  end
end
