# frozen_string_literal: true

module Common
  class File
    def initialize(id, size)
      @id = id
      @size = size
      @moved = false
    end
    attr_accessor :id, :size, :moved
  end

  class Space
    def initialize(size)
      @size = size
    end
    attr_accessor :size
  end

  class Disk
    def initialize
      @disk_map = []
      @id = 0
    end

    # @param size [Integer]
    # @return [void]
    def add_file(size)
      @disk_map << File.new(@id, size)
      @id += 1
      nil
    end

    # @param size [Integer]
    # @return [void]
    def add_space(size)
      return if size.zero?

      @disk_map << Space.new(size)
    end

    # @return [File]
    def pop_last_file
      idx = @disk_map.size - 1
      until @disk_map[idx].is_a? File
        idx = idx.pred
        return nil if idx.negative?
      end
      @disk_map.delete_at(idx)
    end

    # @return [File]
    def shift_first_file
      idx = 0
      until @disk_map[idx].is_a? File
        idx = idx.succ
        return nil if idx >= @disk_map.size
      end
      @disk_map.delete_at(idx)
    end

    # @return [Space]
    def shift_first_space
      idx = 0
      until @disk_map[idx].is_a? Space
        idx = idx.succ
        return nil if idx >= @disk_map.size
      end
      @disk_map.delete_at(idx)
    end

    def full_file_defrag_and_sum
      # find_last_unmoved_file
      # try to fit file in all spaces
      # if fits, restart process

      idx = @disk_map.size - 1
      loop do
        until @disk_map[idx].is_a?(File) && !@disk_map[idx].moved
          idx = idx.pred
          break if idx.negative?
        end

        break if idx.negative?

        last_unmoved_file = @disk_map[idx]

        sdx = 0
        while sdx < idx
          if @disk_map[sdx].is_a?(Space) && @disk_map[sdx].size >= (last_unmoved_file.size)
            @disk_map[idx] = Space.new(last_unmoved_file.size)
            last_unmoved_file.moved = true

            if @disk_map[sdx].size > last_unmoved_file.size
              new_space = Space.new(@disk_map[sdx].size - last_unmoved_file.size)
              @disk_map.delete_at(sdx)
              @disk_map.insert(sdx, last_unmoved_file, new_space)
            else
              @disk_map[sdx] = last_unmoved_file
            end

            cdx = 0
            while cdx < @disk_map.size - 1
              if @disk_map[cdx].is_a?(Space) && @disk_map[cdx + 1].is_a?(Space)
                @disk_map[cdx].size += @disk_map[cdx + 1].size
                @disk_map.delete_at(cdx + 1)
                cdx = 0
              end
              cdx = cdx.succ
            end

            idx = @disk_map.find_index { |v| v.is_a?(File) && v.id == last_unmoved_file.id - 1 } + 1
            break
          end
          sdx = sdx.succ
        end
        idx = idx.pred
      end
      checksum = 0
      curr_char = 0
      @disk_map.each do |d|
        if d.is_a? Space
          curr_char += d.size
          next
        end

        d.size.times do
          checksum += curr_char * d.id
          p "#{curr_char} * #{d.id}"
          curr_char = curr_char.succ
        end
      end
      checksum
    end

    # @return [Integer]
    def defrag_and_sum
      checksum = 0
      curr_char = 0
      curr_file = nil
      curr_space = shift_first_space
      curr_space.size

      last_file = pop_last_file
      loop do
        curr_file = shift_first_file

        idx = 0
        while curr_file && idx < curr_file.size
          checksum += curr_file.id * curr_char
          curr_char = curr_char.succ
          idx = idx.succ
        end

        while curr_space.size > 0 && last_file
          if last_file.size > 0
            checksum += last_file.id * curr_char
            curr_char = curr_char.succ
            last_file.size = last_file.size.pred
            curr_space.size = curr_space.size.pred
          else
            last_file = pop_last_file
          end
        end
        curr_space = shift_first_space if curr_space.size == 0

        break if !curr_file && !last_file
      end

      checksum
    end
  end

  class << self
  end
end
