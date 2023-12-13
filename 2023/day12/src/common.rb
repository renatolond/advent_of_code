# frozen_string_literal: true

Record = Data.define(:list, :sizes)

module Common
  class << self
    # @param line [String] The line as read from the terminal
    # @return [Record]
    def read_line(line)
      list, sizes = line.strip.split
      sizes = sizes.split(",").map(&:to_i)
      Record.new(list, sizes)
    end

    # @param record [Record] a record to calculate the damaged check
    # @return [List(Array<Integer>, Integer)]
    def damaged_check(record)
      check = []
      open_count = 0
      last_char = nil
      record.list.each_char do |char|
        if char == last_char
          open_count += 1
        else
          if last_char == "?"
            check << -open_count
          elsif last_char == "#"
            check << open_count
          elsif last_char == "."
            check << 0
          end
          open_count = 1
          last_char = char
        end
      end
      if last_char == "?"
        check << -open_count
      elsif last_char == "#"
        check << open_count
      elsif last_char == "."
        check << 0
      end

      check
    end

    def aggregate_result(result)
      agg = []
      sum = 0
      result.each do |r|
        if r.zero?
          agg << sum if sum != 0
          sum = 0
        else
          sum += r.abs
        end
      end
      agg << sum if sum != 0
      agg
    end

    def recursive_stuff(curr_string, curr_char, regular_missing, damaged_missing, expected_sizes)
      new_string = curr_string.sub("?", curr_char)
      result = damaged_check(Record.new(new_string, expected_sizes))
      # agg = aggregate_result(result)
      # kept_result = result.dup
      first_negative_number = result.index(&:negative?) || 0
      last_positive_number_that_can_change = first_negative_number - 1
      last_positive_number_that_can_change = 0 if last_positive_number_that_can_change.negative?
      last_positive_number_that_can_change -= 1 if result[last_positive_number_that_can_change].zero? && last_positive_number_that_can_change.positive?

      idx = 0
      jdx = 0
      loop do
        break unless idx < result.size
        break if result[idx].negative?
        next if result[idx].zero?
        return 0 if jdx >= expected_sizes.size
        return 0 if result[idx] > expected_sizes[jdx]
        return 0 if result[idx] < expected_sizes[jdx] && idx != last_positive_number_that_can_change

        jdx += 1
      ensure
        idx += 1
      end
      result.keep_if(&:positive?)

      valid_permutations = 0
      valid_permutations += recursive_stuff(new_string, ".", regular_missing - 1, damaged_missing, expected_sizes) unless regular_missing.zero?
      valid_permutations += recursive_stuff(new_string, "#", regular_missing, damaged_missing - 1, expected_sizes) unless damaged_missing.zero?
      valid_permutations += 1 if result == expected_sizes && regular_missing.zero? && damaged_missing.zero?
      valid_permutations
    end

    # @param record [Record] A record to calculate permutations for
    def calculate_permutations(record)
      # @type [String]
      list = record.list
      missing_spots = list.count("?")
      damaged_spots = list.count("#")
      all_damaged = record.sizes.sum
      damaged_missing = all_damaged - damaged_spots
      raise "IMPOSSIBRU" if missing_spots < damaged_missing

      regular_missing = missing_spots - damaged_missing
      valid_permutations = 0
      valid_permutations += recursive_stuff(list, "#", regular_missing, damaged_missing - 1, record.sizes) unless damaged_missing.zero?
      valid_permutations += recursive_stuff(list, ".", regular_missing - 1, damaged_missing, record.sizes) unless regular_missing.zero?

      valid_permutations
    end

    # @param record [Record]
    # @return [Record]
    def expand_record(record)
      new_list = ([record.list] * 5).join("?")
      Record.new(new_list, record.sizes * 5)
    end
  end
end
