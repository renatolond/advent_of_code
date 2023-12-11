# frozen_string_literal: true

module Common
  class << self
    def read_input(io)
      universe = []
      while (line = io.gets)
        line = line.strip
        universe << line.strip
      end
      universe
    end

    def find_expansion_paths(map)
      idx = 0
      expansion = []
      while idx < map.size
        jdx = 0
        found_stars = false
        while jdx < map.first.size
          if map[idx][jdx] == "#"
            found_stars = true
            break
          end
          jdx += 1
        end
        expansion << [idx, -1] unless found_stars
        idx += 1
      end

      idx = 0
      while idx < map.first.size
        jdx = 0
        found_stars = false
        while jdx < map.size
          if map[jdx][idx] == "#"
            found_stars = true
            break
          end
          jdx += 1
        end
        expansion << [-1, idx] unless found_stars
        idx += 1
      end

      expansion
    end

    def find_galaxies(map)
      galaxies = []
      map.each_with_index do |line, idx|
        jdx = 0
        line.each_char do |chr|
          galaxies << [idx, jdx] if chr == "#"
          jdx += 1
        end
      end
      galaxies
    end

    def manhattan_distance(g1, g2, expansion_paths:, expansion_factor: 2)
      x1, x2 = [g1.first, g2.first].sort
      y1, y2 = [g1.last, g2.last].sort
      hor_exp = 0
      ver_exp = 0
      expansion_paths.each do |ep|
        hor_exp += 1 if ep[0].between?(x1, x2)
        ver_exp += 1 if ep[1].between?(y1, y2)
      end

      dist = (x2 - x1) + (hor_exp * (expansion_factor - 1)) + (y2 - y1) + (ver_exp * (expansion_factor - 1))
    end
  end
end
