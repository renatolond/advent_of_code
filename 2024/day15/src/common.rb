# frozen_string_literal: true

module Common
  class Robot
    def initialize(y, x)
      @y = y
      @x = x
    end
    attr_accessor :y, :x

    def consume_instructions(instructions, warehouse)
      Common.set_warehouse_size(warehouse.size, warehouse.first.size)
      instructions = instructions.chars
      while (instruction = instructions.shift)
        case instruction
        when "<"
          Common.push_left(warehouse, y, x - 1)
          move_left! if warehouse[y][x - 1] == "."
        when "^"
          Common.push_up(warehouse, y - 1, x)
          move_up! if warehouse[y - 1][x] == "."
        when ">"
          Common.push_right(warehouse, y, x + 1)
          move_right! if warehouse[y][x + 1] == "."
        when "v"
          Common.push_down(warehouse, y + 1, x)
          move_down! if warehouse[y + 1][x] == "."
        end
        # print cursor.clear_screen_up
        # print cursor.move(0, 0)
        # warehouse.each_with_index { |w, i| w.chars.each_with_index { |ww, j| (print(instruction); next) if y == i && x == j; print(ww) }; puts "" }
        # sleep(0.1)
      end
    end

    def move_left!
      @x -= 1
    end

    def move_right!
      @x += 1
    end

    def move_up!
      @y -= 1
    end

    def move_down!
      @y += 1
    end
  end
  class << self
    def set_warehouse_size(y, x)
      @size_y = y
      @size_x = x
    end

    def push_left(warehouse, y, x)
      return unless x >= 0
      return if warehouse[y][x] == "#"
      return if warehouse[y][x] == "."

      push_left(warehouse, y, x - 1)
      return unless warehouse[y][x - 1] == "."

      warehouse[y][x - 1] = warehouse[y][x]
      warehouse[y][x] = "."
    end

    def push_up(warehouse, y, x)
      return unless y >= 0
      return if warehouse[y][x] == "#"
      return if warehouse[y][x] == "."

      if warehouse[y][x] == "O"
        push_up(warehouse, y - 1, x)
        return unless warehouse[y - 1][x] == "."

        warehouse[y - 1][x] = warehouse[y][x]
        warehouse[y][x] = "."
      elsif warehouse[y][x] == "["
        return unless can_move_up(warehouse, y - 1, x, x + 1)

        push_up(warehouse, y - 1, x)
        push_up(warehouse, y - 1, x + 1)
        return unless warehouse[y - 1][x] == "." && warehouse[y - 1][x + 1] == "."

        warehouse[y - 1][x] = warehouse[y][x]
        warehouse[y - 1][x + 1] = warehouse[y][x + 1]
        warehouse[y][x] = warehouse[y][x + 1] = "."
      elsif warehouse[y][x] == "]"
        return unless can_move_up(warehouse, y - 1, x - 1, x)

        push_up(warehouse, y - 1, x)
        push_up(warehouse, y - 1, x - 1)
        return unless warehouse[y - 1][x] == "." && warehouse[y - 1][x - 1] == "."

        warehouse[y - 1][x] = warehouse[y][x]
        warehouse[y - 1][x - 1] = warehouse[y][x - 1]
        warehouse[y][x - 1] = warehouse[y][x] = "."
      end
    end

    def can_move_up(warehouse, y, x, x2)
      return false if warehouse[y][x] == "#" || warehouse[y][x2] == "#"
      return true if warehouse[y][x] == "." && warehouse[y][x2] == "."
      return can_move_up(warehouse, y - 1, x, x2) if warehouse[y][x] == "["

      possible = true
      possible &= can_move_up(warehouse, y - 1, x - 1, x) if warehouse[y][x] == "]"
      possible &= can_move_up(warehouse, y - 1, x2, x2 + 1) if warehouse[y][x2] == "["
      possible
    end

    def push_right(warehouse, y, x)
      return unless x < @size_x
      return if warehouse[y][x] == "#"
      return if warehouse[y][x] == "."

      push_right(warehouse, y, x + 1)
      return unless warehouse[y][x + 1] == "."

      warehouse[y][x + 1] = warehouse[y][x]
      warehouse[y][x] = "."
    end

    def push_down(warehouse, y, x)
      return unless y < @size_y
      return if warehouse[y][x] == "#"
      return if warehouse[y][x] == "."

      if warehouse[y][x] == "O"
        push_down(warehouse, y + 1, x)
        return unless warehouse[y + 1][x] == "."

        warehouse[y + 1][x] = warehouse[y][x]
        warehouse[y][x] = "."
      elsif warehouse[y][x] == "["
        return unless can_move_down(warehouse, y + 1, x, x + 1)

        push_down(warehouse, y + 1, x)
        push_down(warehouse, y + 1, x + 1)
        return unless warehouse[y + 1][x] == "." && warehouse[y + 1][x + 1] == "."

        warehouse[y + 1][x] = warehouse[y][x]
        warehouse[y + 1][x + 1] = warehouse[y][x + 1]
        warehouse[y][x] = warehouse[y][x + 1] = "."
      elsif warehouse[y][x] == "]"
        return unless can_move_down(warehouse, y + 1, x - 1, x)

        push_down(warehouse, y + 1, x)
        push_down(warehouse, y + 1, x - 1)
        return unless warehouse[y + 1][x] == "." && warehouse[y + 1][x - 1] == "."

        warehouse[y + 1][x] = warehouse[y][x]
        warehouse[y + 1][x - 1] = warehouse[y][x - 1]
        warehouse[y][x - 1] = warehouse[y][x] = "."
      end
    end
    def can_move_down(warehouse, y, x, x2)
      return false if warehouse[y][x] == "#" || warehouse[y][x2] == "#"
      return true if warehouse[y][x] == "." && warehouse[y][x2] == "."
      return can_move_down(warehouse, y + 1, x, x2) if warehouse[y][x] == "["

      possible = true
      possible &= can_move_down(warehouse, y + 1, x - 1, x) if warehouse[y][x] == "]"
      possible &= can_move_down(warehouse, y + 1, x2, x2 + 1) if warehouse[y][x2] == "["
      possible
    end
  end
end
