# frozen_string_literal: true

module Common
  class << self
    def tick(map, direction = :up)
      new_map = Array.new(map.size)

      case direction
      when :up
        idx = 0
        next_idx = 1
        org_jdx = 0
        org_next_jdx = 0
        idx_incr = 1
        jdx_incr = 1
        final_idx = map.size
        final_jdx = map.first.size
      else
        raise "Not Implemented!!"
      end

      map.each_with_index do |l, i|
        new_map[i] = l.dup
        map[i] = map[i].dup
      end
      changed = false
      loop do
        break if next_idx == final_idx

        jdx = org_jdx
        next_jdx = org_next_jdx
        loop do
          break if next_jdx == final_jdx

          case new_map[idx][jdx]
          when "."
            if map[next_idx][next_jdx] == "O"
              new_map[idx][jdx] = map[next_idx][next_jdx]
              new_map[next_idx][next_jdx] = "."
              map[next_idx][next_jdx] = "."
              puts "=========######"
              puts new_map[idx]
              puts new_map[next_idx]
              puts "=========######"
              changed = true
            end
          end
        ensure
          jdx += jdx_incr
          next_jdx += jdx_incr
        end
        new_map
      ensure
        idx += idx_incr
        next_idx += idx_incr
      end

      return new_map, changed
    end
  end
end
