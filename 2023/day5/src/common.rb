# frozen_string_literal: true

Map = Data.define(:source, :destination)

class Range
  def intersect?(other)
    raise ArgumentError, "value must be a Range" unless other.is_a?(Range)
    # This only works because I'm only using ranges excluding end
    return false if other.begin > self.end - 1 || self.begin > other.end - 1

    true
  end
end

module Common
  class << self
    # @param maps [Array<Map>] Maps from destination to source
    # @param values [Array<Integer>] values to be converted
    # @return [Array<Integer>] Mapped values
    def convert(maps, values)
      final_values = values.dup
      maps.each do |map|
        idx = 0
        values.each do |v|
          next unless map.source.cover? v

          distance = map.destination.begin - map.source.begin
          final_values[idx] = v + distance
        ensure
          idx += 1
        end
      end
      final_values
    end

    def split_ranges(maps, values)
      new_ranges = []
      # prepare ranges by splitting
      maps.each do |map|
        idx = 0
        while idx < values.size
          v = values[idx]
          next if v.nil?

          unless map.source.intersect?(v) && !map.source.cover?(v)
            idx += 1
            next
          end

          # puts "#{v.begin} - #{v.end} | #{map.source.begin} - #{map.source.end}"
          intersection_before = [v.begin, map.source.begin].max
          intersection_after = [v.end, map.source.end].min

          new_ranges << (v.begin...intersection_before) if intersection_before > v.begin
          new_ranges << (intersection_before...intersection_after)
          new_ranges << (intersection_after...v.end) if intersection_after <= v.end - 1
          values[idx] = nil
          idx += 1
        end
        values = (values + new_ranges).compact
        new_ranges = []
      end

      (values + new_ranges).compact.sort_by(&:begin)
    end

    # @param maps [Array<Map>] Maps from destination to source
    # @param values [Array<Range<Integer>>] values to be converted
    # @return [Array<Range<Integer>>] Mapped values
    def convert_ranges(maps, values)
      values = split_ranges(maps, values)
      final_values = values.dup

      maps.each do |map|
        idx = 0
        values.each do |v|
          next unless map.source.cover? v

          distance = map.destination.begin - map.source.begin
          new_beginning = v.begin + distance
          final_values[idx] = (new_beginning...(new_beginning + v.size))
        ensure
          idx += 1
        end
      end

      final_values
    end

    # @param line [String]
    # @return [Map]
    def read_map_line(line)
      destination, source, range_size = line.split.map(&:to_i)
      Map.new(destination: destination...(destination + range_size), source: source...(source + range_size))
    end
  end
end
