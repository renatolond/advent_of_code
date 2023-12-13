# frozen_string_literal: true

module Common
  class << self
    # @param map [Array<String>] Strings forming the map
    def process_map_with_smudge(map)
      standard_simmetry = process_map(map)
      idx = 0
      map.each_cons(2) do |a, b|
        is_equal = (a == b)
        single_diff = cheating_levenshtein(a, b) unless is_equal
        remaining_distance = is_equal ? 1 : 0

        if is_equal || single_diff
          new_idx, new_jdx = check_map_for_smudge(map, idx, remaining_distance)
          next if new_idx == false

          map[new_idx] = map[new_jdx]
          return process_map(map, standard_simmetry)
        end
      ensure
        idx += 1
      end

      original_map = map
      map = transpose_map(map)
      idx = 0
      map.each_cons(2) do |a, b|
        is_equal = (a == b)
        single_diff = cheating_levenshtein(a, b) unless is_equal
        remaining_distance = is_equal ? 1 : 0
        if is_equal || single_diff
          new_idx, new_jdx = check_map_for_smudge(map, idx, remaining_distance)
          next if new_idx == false

          original_map.map do |str|
            str[new_idx] = str[new_jdx]
            str
          end
          return process_map(original_map, standard_simmetry)
        end
      ensure
        idx += 1
      end

      return :none, 0
    end

    def check_map_for_smudge(map, potential_mirror_idx, distance)
      idx = potential_mirror_idx
      jdx = potential_mirror_idx + 1

      if distance.zero?
        location_idx = idx
        location_jdx = jdx
        idx -= 1
        jdx += 1
      end

      loop do
        break if idx.negative? || jdx >= map.size

        if distance.zero?
          return false if map[idx] != map[jdx]
        elsif distance == 1
          next if map[idx] == map[jdx]

          result = cheating_levenshtein(map[idx], map[jdx])
          return false unless result

          location_idx = idx
          location_jdx = jdx

          distance -= 1
        end
      ensure
        idx -= 1
        jdx += 1
      end

      return false if distance == 1
      return false if location_idx.nil?

      return location_idx, location_jdx
    end

    def cheating_levenshtein(a, b, curr_distance = 0)
      if a.empty? && b.empty?
        curr_distance == 1
      elsif a[0] == b[0]
        cheating_levenshtein(a[1..], b[1..], curr_distance)
      elsif curr_distance.zero?
        cheating_levenshtein(a[1..], b[1..], 1)
      else
        false
      end
    end

    def process_map(map, ignoring = nil)
      idx = 0
      map.each_cons(2) do |a, b|
        if a == b && check_map(map, idx)
          ret = [:vertical, idx + 1]
          next if ret == ignoring

          return ret
        end
      ensure
        idx += 1
      end

      map = transpose_map(map)
      idx = 0
      map.each_cons(2) do |a, b|
        if a == b && check_map(map, idx)
          ret = [:horizontal, idx + 1]
          next if ret == ignoring

          return ret
        end
      ensure
        idx += 1
      end
      return :vertical, 0
    end

    def check_map(map, potential_mirror_idx)
      idx = potential_mirror_idx
      jdx = potential_mirror_idx + 1

      loop do
        break if idx.negative? || jdx >= map.size

        return false if map[idx] != map[jdx]
      ensure
        idx -= 1
        jdx += 1
      end

      true
    end

    def transpose_map(map)
      new_map = Array.new(map.first.size) { +"" }

      map.each do |l|
        idx = 0
        l.chars.each do |c|
          new_map[idx] += c
        ensure
          idx += 1
        end
      end
      new_map
    end
  end
end
