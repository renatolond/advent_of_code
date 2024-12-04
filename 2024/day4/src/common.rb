# frozen_string_literal: true

module Common
  class XmasFinder
    def initialize
      @lines = []
    end

    # @param line [String] A line of possible xmas
    # @return [void]
    def add_line(line)
      line = "...#{line.strip}..."
      if @lines.empty?
        padding_line = "." * line.size
        3.times do
          @lines << padding_line
        end
      end
      @lines << line
    end

    XMAS = "XMAS"

    # Finds xmas on all directions
    # @return [Integer] The number of xmas
    def find_xmas
      end_idx = @lines.size
      end_jdx = @lines.first.size - 3
      3.times do
        @lines << @lines.first
      end
      idx = 2
      total_xmas = 0
      while idx < end_idx
        jdx = 2

        while jdx < end_jdx
          if @lines[idx][jdx] == XMAS[0]
            total_xmas += find_u(idx, jdx, 0)
            total_xmas += find_d(idx, jdx, 0)
            total_xmas += find_l(idx, jdx, 0)
            total_xmas += find_r(idx, jdx, 0)
            total_xmas += find_ul(idx, jdx, 0)
            total_xmas += find_ur(idx, jdx, 0)
            total_xmas += find_dl(idx, jdx, 0)
            total_xmas += find_dr(idx, jdx, 0)
          end
          jdx += 1
        end
        idx += 1
      end

      total_xmas
    end

    def find_u(idx, jdx, xmas_idx)
      return 1 if xmas_idx >= XMAS.size
      return find_u(idx - 1, jdx, xmas_idx + 1) if @lines[idx][jdx] == XMAS[xmas_idx]

      0
    end

    def find_d(idx, jdx, xmas_idx)
      return 1 if xmas_idx >= XMAS.size
      return find_d(idx + 1, jdx, xmas_idx + 1) if @lines[idx][jdx] == XMAS[xmas_idx]

      0
    end

    def find_l(idx, jdx, xmas_idx)
      return 1 if xmas_idx >= XMAS.size
      return find_l(idx, jdx - 1, xmas_idx + 1) if @lines[idx][jdx] == XMAS[xmas_idx]

      0
    end

    def find_r(idx, jdx, xmas_idx)
      return 1 if xmas_idx >= XMAS.size
      return find_r(idx, jdx + 1, xmas_idx + 1) if @lines[idx][jdx] == XMAS[xmas_idx]

      0
    end

    def find_ul(idx, jdx, xmas_idx)
      return 1 if xmas_idx >= XMAS.size
      return find_ul(idx - 1, jdx - 1, xmas_idx + 1) if @lines[idx][jdx] == XMAS[xmas_idx]

      0
    end

    def find_ur(idx, jdx, xmas_idx)
      return 1 if xmas_idx >= XMAS.size
      return find_ur(idx - 1, jdx + 1, xmas_idx + 1) if @lines[idx][jdx] == XMAS[xmas_idx]

      0
    end

    def find_dl(idx, jdx, xmas_idx)
      return 1 if xmas_idx >= XMAS.size
      return find_dl(idx + 1, jdx - 1, xmas_idx + 1) if @lines[idx][jdx] == XMAS[xmas_idx]

      0
    end

    def find_dr(idx, jdx, xmas_idx)
      return 1 if xmas_idx >= XMAS.size
      return find_dr(idx + 1, jdx + 1, xmas_idx + 1) if @lines[idx][jdx] == XMAS[xmas_idx]

      0
    end

    # Finds mas on the shape of X
    # @return [Integer] The number of x-mas
    def find_x_mas
      end_idx = @lines.size
      end_jdx = @lines.first.size - 3
      3.times do
        @lines << @lines.first
      end
      idx = 2
      total_x_mas = 0
      while idx < end_idx
        jdx = 2

        while jdx < end_jdx
          if @lines[idx][jdx] == XMAS[2]
            total_x_mas += find_x_mas_or1(idx, jdx)
            total_x_mas += find_x_mas_or2(idx, jdx)
            total_x_mas += find_x_mas_or3(idx, jdx)
            total_x_mas += find_x_mas_or4(idx, jdx)
          end
          jdx += 1
        end
        idx += 1
      end

      total_x_mas
    end

    # M S
    #  A
    # M S
    def find_x_mas_or1(idx, jdx)
      if @lines[idx - 1][jdx - 1] == "M" &&
         @lines[idx + 1][jdx - 1] == "M" &&
         @lines[idx - 1][jdx + 1] == "S" &&
         @lines[idx + 1][jdx + 1] == "S"
        return 1
      end

      0
    end

    # M M
    #  A
    # S S
    def find_x_mas_or2(idx, jdx)
      if @lines[idx - 1][jdx - 1] == "M" &&
         @lines[idx - 1][jdx + 1] == "M" &&
         @lines[idx + 1][jdx - 1] == "S" &&
         @lines[idx + 1][jdx + 1] == "S"
        return 1
      end

      0
    end

    # S M
    #  A
    # S M
    def find_x_mas_or3(idx, jdx)
      if @lines[idx - 1][jdx - 1] == "S" &&
         @lines[idx + 1][jdx - 1] == "S" &&
         @lines[idx - 1][jdx + 1] == "M" &&
         @lines[idx + 1][jdx + 1] == "M"
        return 1
      end

      0
    end

    # S S
    #  A
    # M M
    def find_x_mas_or4(idx, jdx)
      if @lines[idx - 1][jdx - 1] == "S" &&
         @lines[idx - 1][jdx + 1] == "S" &&
         @lines[idx + 1][jdx - 1] == "M" &&
         @lines[idx + 1][jdx + 1] == "M"
        return 1
      end

      0
    end
  end
end
