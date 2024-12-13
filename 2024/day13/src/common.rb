# frozen_string_literal: true

module Common
  Button = Data.define(:name, :x, :y)
  Point = Data.define(:x, :y)
  COST = {
    "A" => 3,
    "B" => 1
  }
  class << self
    MAX_TOSS = 100

    def math_solving(x, y, buttons)
      xa = buttons["A"].x
      ya = buttons["A"].y
      xb = buttons["B"].x
      yb = buttons["B"].y

      top_b = (y * xa) - (x * ya)
      low_b = (yb * xa) - (xb * ya)
      return nil if top_b % low_b != 0

      b = top_b / low_b
      a = (x - (b * xb))
      return nil if a % xa != 0

      a /= xa

      (a * COST["A"]) + (b * COST["B"])
    end

    def solve_for(x, y, buttons)
      cost_matrix = Array.new(MAX_TOSS) { Array.new(MAX_TOSS, nil) }
      cost_matrix[0][0] = Point.new(0, 0)
      MAX_TOSS.times do |idx|
        next if idx.zero?

        cost_matrix[idx][0] = Point.new(
          cost_matrix[idx - 1][0].x + buttons["A"].x,
          cost_matrix[idx - 1][0].y + buttons["A"].y
        )
        cost_matrix[0][idx] = Point.new(
          cost_matrix[0][idx - 1].x + buttons["B"].x,
          cost_matrix[0][idx - 1].y + buttons["B"].y
        )
      end

      MAX_TOSS.times do |idx|
        next if idx.zero?

        idy = idx
        while idy < MAX_TOSS
          cost_matrix[idy][idx] = Point.new(
            cost_matrix[idy - 1][idx].x + buttons["A"].x,
            cost_matrix[idy - 1][idx].y + buttons["A"].y
          )
          cost_matrix[idx][idy] = Point.new(
            cost_matrix[idx][idy - 1].x + buttons["B"].x,
            cost_matrix[idx][idy - 1].y + buttons["B"].y
          )

          idy += 1
        end
      end

      cost = Float::INFINITY

      MAX_TOSS.times do |idx|
        MAX_TOSS.times do |idy|
          next unless cost_matrix[idx][idy].x == x && cost_matrix[idx][idy].y == y

          curr_cost = (idx * COST["A"]) + (idy * COST["B"])
          cost = curr_cost if curr_cost < cost
        end
      end

      return nil if cost == Float::INFINITY

      cost
    end
  end
end
