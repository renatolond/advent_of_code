# TODO: Write documentation for `Day23`
module Day23
  VERSION = "0.1.0"

  struct OrganizationState
    property hallway
    property first_row
    property nth_rows
    def initialize(@hallway : Array(Char), @first_row : Array(Char), @nth_rows : Array(Array(Char)))
    end
  end

  class AmphipodOrganizer
    def initialize(folded = true)
      @amphipod_state = [] of Array(Char)
      @place_map = [] of Array(Char)
      @width = -9999
      @designated_positions = [] of Tuple(Int32, Int32, Char)
      @folded = folded
    end

    def current_state
      @amphipod_state.map(&.join)
    end

    def rooms_map
      @place_map.map(&.join)
    end

    AMPHIPOD_TYPES = {
      'D' => 1000_i64,
      'C' => 100_i64,
      'B' => 10_i64,
      'A' => 1_i64
    }

    def read_line(line)
      if @width < 0
        @width = line.chars.size
      end
      if line.chars.size < @width
        line = line + " " * (@width - line.chars.size)
      end
      line = line.tr(" ", "#")
      line_chars = line.chars

      @amphipod_state << line_chars
      order = ['A', 'B', 'C', 'D']
      line_chars = line_chars.map do |c|
        if 'A' <= c && c <= 'D'
          order.shift
        else
          c
        end
      end
      @place_map << line_chars
    end


    def amphipod_state : OrganizationState
      hallway = @amphipod_state[1].select { |v| v != '#' }
      first_row = @amphipod_state[2].select { |v| AMPHIPOD_TYPES.keys.includes?(v) }
      second_row = @amphipod_state[3].select { |v| AMPHIPOD_TYPES.keys.includes?(v) }
      nth_rows = [] of Array(Char)
      if !@folded
        nth_rows << ['D', 'C', 'B', 'A']
        nth_rows << ['D', 'B', 'A', 'C']
      end
      nth_rows << second_row

      OrganizationState.new(hallway, first_row, nth_rows)
    end

    def amphipod_destination : OrganizationState
      hallway = @place_map[1].select { |v| v != '#' }
      first_row = @place_map[2].select { |v| AMPHIPOD_TYPES.keys.includes?(v) }
      second_row = @place_map[3].select { |v| AMPHIPOD_TYPES.keys.includes?(v) }
      nth_rows = [] of Array(Char)
      if !@folded
        nth_rows << ['A', 'B', 'C', 'D']
        nth_rows << ['A', 'B', 'C', 'D']
      end
      nth_rows << second_row

      OrganizationState.new(hallway, first_row, nth_rows)
    end

    AMPHIPOD_POSITIONS = {
      'A' => 0,
      'B' => 1,
      'C' => 2,
      'D' => 3
    }

    ROOM_POSITIONS_IN_THE_HALLWAY = {
      0 => 2,
      1 => 4,
      2 => 6,
      3 => 8
    }
    def can_move_from_hallway_to_first_row?(idx, hallway, first_row)
      amphipod = hallway[idx]
      room_position = AMPHIPOD_POSITIONS[amphipod]
      return nil if first_row[room_position] != '.'
      per_move = AMPHIPOD_TYPES[amphipod]
      energy = per_move # Energy to move from room to hallway

      end_at = ROOM_POSITIONS_IN_THE_HALLWAY[room_position]
      direction = if ROOM_POSITIONS_IN_THE_HALLWAY[room_position] < idx
        -1
      elsif ROOM_POSITIONS_IN_THE_HALLWAY[room_position] > idx
        1
      end

      if direction
        pos = idx + direction
        while pos != end_at
          return nil if hallway[pos] != '.'
          energy += per_move
          pos += direction
        end
        return nil if hallway[pos] != '.'
        energy += per_move
      end

      return energy
    end

    # Assumes previous rows were already checked
    def can_move_from_hallway_to_nth_row?(n, idx, hallway, nth_row)
      raise "oh no" if n < 2 || n > 4
      energy = can_move_from_hallway_to_first_row?(idx, hallway, nth_row)
      return unless energy
      amphipod = hallway[idx]
      per_move = AMPHIPOD_TYPES[amphipod]
      n -= 1
      n.times do |ndx|
        energy += per_move # energy to move from nth row to n-1th row
      end
      energy
    end

    # Assumes previous rows were already checked
    def can_move_from_nth_row_to_hallway?(n, idx, hallway, jdx, nth_row) : Int64?
      raise "oh no" if n < 2 || n > 4
      energy = can_move_from_first_row_to_hallway?(idx, hallway, jdx, nth_row)
      return unless energy
      per_move = AMPHIPOD_TYPES[nth_row[jdx]]
      n -= 1
      n.times do |ndx|
        energy += per_move # energy to move from nth row to n-1th row
      end
      energy
    end

    def can_move_from_first_row_to_hallway?(idx, hallway, jdx, first_row) : Int64?
      return nil if ROOM_POSITIONS_IN_THE_HALLWAY.values.includes?(idx)
      per_move = AMPHIPOD_TYPES[first_row[jdx]]
      energy = per_move # Energy to move from room to hallway

      start_from = ROOM_POSITIONS_IN_THE_HALLWAY[jdx]
      direction = if ROOM_POSITIONS_IN_THE_HALLWAY[jdx] < idx
        1
      elsif ROOM_POSITIONS_IN_THE_HALLWAY[jdx] > idx
        -1
      end

      if direction
        pos = start_from
        while pos != idx
          return nil if hallway[pos] != '.'
          energy += per_move
          pos += direction
        end
      end

      return energy
    end

    def generate_movements_for(state : OrganizationState) : Array(Tuple(Int64, OrganizationState))
      movements = [] of Tuple(Int64, OrganizationState)
      hallway = state.hallway
      first_row = state.first_row
      nth_rows = state.nth_rows

      hallway.each_with_index do |h, idx|
        next if h == '.'
        room_position = AMPHIPOD_POSITIONS[h]
        next unless first_row[room_position] == '.'

        if nth_rows.select { |row| row[room_position] != h }.empty?
          move_cost = nil
          move_cost = can_move_from_hallway_to_first_row?(idx, hallway, first_row)
          if move_cost
            new_hallway = hallway.dup
            new_hallway[idx] = '.'
            new_first_row = first_row.dup
            new_first_row[room_position] = h
            movements << {move_cost, OrganizationState.new(new_hallway, new_first_row, nth_rows)}
          end
        end

        nth_rows.each_with_index do |row, i|
          break unless row[room_position] == '.'

          next_rows = if i < nth_rows.size - 1
                        nth_rows[i+1..]
                      else
                        [] of Array(Char)
                      end
          if next_rows.select { |row| row[room_position] != h }.empty?
            move_cost = nil
            move_cost = can_move_from_hallway_to_nth_row?(i+2, idx, hallway, row)
            if move_cost
              new_hallway = hallway.dup
              new_hallway[idx] = '.'
              new_second_row = row.dup
              new_second_row[room_position] = h
              prev_rows = if i > 0
                            nth_rows[..i-1]
                          else
                            [] of Array(Char)
                          end
              new_nth_rows = prev_rows + [new_second_row] + next_rows
              movements << {move_cost, OrganizationState.new(new_hallway, first_row, new_nth_rows)}
            end
          end
        end
      end

      4.times do |idx|
        a = first_row[idx]
        next if a == '.'
        next if AMPHIPOD_POSITIONS[a] == idx && nth_rows.select { |row| row[idx] != a }.empty?

        hallway.each_with_index do |h, jdx|
          next if h != '.'

          move_cost = can_move_from_first_row_to_hallway?(jdx, hallway, idx, first_row)
          if move_cost
            new_hallway = hallway.dup
            new_hallway[jdx] = a
            new_first_row = first_row.dup
            new_first_row[idx] = '.'
            movements << {move_cost, OrganizationState.new(new_hallway, new_first_row, nth_rows)}
          end
        end
      end

      4.times do |idx|
        next if first_row[idx] != '.'
        nth_rows.each_with_index do |row, i|
          prev_rows = if i > 0
            nth_rows[..i-1]
          else
            [] of Array(Char)
          end
          break unless prev_rows.select { |row| row[idx] != '.' }.empty?
          a = row[idx]
          next if a == '.'
          next_rows = if i < nth_rows.size - 1
                        nth_rows[i+1..]
                      else
                        [] of Array(Char)
                      end
          next if AMPHIPOD_POSITIONS[a] == idx && next_rows.select { |row| row[idx] != a }.empty?

          hallway.each_with_index do |h, jdx|
            next if h != '.'

            move_cost = can_move_from_nth_row_to_hallway?(i+2, jdx, hallway, idx, row)
            if move_cost
              new_hallway = hallway.dup
              new_hallway[jdx] = a
              new_first_row = first_row
              new_second_row = row.dup
              new_second_row[idx] = '.'
              new_nth_rows = prev_rows + [new_second_row] + next_rows
              movements << {move_cost, OrganizationState.new(new_hallway, new_first_row, new_nth_rows)}
            end
          end
        end
      end

      movements
    end

    def find_path(positions)
      visit_set = [] of NamedTuple(energy: Int64, state: OrganizationState)
      visit_set << {energy: 0_i64, state: positions}

      seen = {} of OrganizationState => Int64
      seen[positions] = 0

      final = amphipod_destination

      iterations = 0
      while !visit_set.empty?
        current_node = visit_set.shift

        return current_node[:energy] if current_node[:state] == final

        generate_movements_for(current_node[:state]).each do |move_energy, new_state|
          total_energy = move_energy + current_node[:energy]
          if !seen.has_key?(new_state) || seen[new_state] > total_energy
            inserted = false
            visit_set.each_with_index do |v, i|
              if v[:energy] > total_energy
                visit_set.insert(i, {energy: total_energy, state: new_state})
                inserted = true
                break
              end
            end
            visit_set << {energy: total_energy, state: new_state} unless inserted
            seen[new_state] = total_energy
          end
        end
        if (iterations % 500) == 0
          puts current_node
          puts "Looked at #{iterations} combinations. Visit set has #{visit_set.size} elements, seen #{seen.size} combinations"
        end

        iterations += 1
      end

      raise "error!"
    end

    def organize
      positions = amphipod_state
      find_path(positions)
    end
  end

  def self.part_1()
    ao = Day23::AmphipodOrganizer.new
    while (line = gets())
      ao.read_line(line)
    end
    puts ao.organize
  end

  def self.part_2()
    ao = Day23::AmphipodOrganizer.new(false)
    while (line = gets())
      ao.read_line(line)
    end
    puts ao.organize
  end
end
