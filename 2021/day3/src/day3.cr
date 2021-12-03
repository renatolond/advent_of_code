# TODO: Write documentation for `Day3`
module Day3
  VERSION = "0.1.0"

  class SubmarineDiagnostics
    MAX_COUNT = 1
    @size : Int64
    @gamma_rate : Int64 | Nil
    @epsilon_rate : Int64 | Nil
    @co2_scrubber_rating : Int64 | Nil
    @oxygen_gen_rating : Int64 | Nil

    def initialize(size)
      @size = size
      # XXX should be MAX_COUNT + 1, but crystal is complaining ¯\_(ツ)_/¯
      @counts = Array(Array(Int64)).new(size) { Array(Int64).new(1 + 1, 0) }
      @inputs = [] of Int64
    end

    def read_report(line)
      idx = 0_i64
      input_num = 0_i64
      line.chars.each do |c|
        n = Int64.new(c)
        @counts[idx][n] += 1
        input_num += (n << (@size - (idx + 1)))
        idx += 1
      end
      @inputs << input_num
    end

    def gamma_rate
      @gamma_rate ||= begin
        g = 0_i64
        @size.times do |idx|
          bigger = nil
          bigger_idx = nil
          (MAX_COUNT + 1).times do |jdx|
            if bigger.nil? || (bigger < @counts[idx][jdx])
              bigger = @counts[idx][jdx]
              bigger_idx = jdx
            end
          end
          raise "oh no" if bigger_idx.nil?
          bigger_idx = bigger_idx << (@size - (idx + 1))
          g += bigger_idx
        end
        g
      end
    end
    def epsilon_rate
      @epsilon_rate ||= begin
        e = gamma_rate
        @size.times do |idx|
          mask = 1_i64 << idx
          e = (mask ^ e)
        end
        e
      end
    end

    def oxygen_gen_rating
      @oxygen_gen_rating ||= begin
        possible_ratings = @inputs.dup
        @size.times do |idx|
          local_counts = Array(Int64).new(MAX_COUNT + 1, 0)
          possible_ratings.each do |r|
            mask = 1_i64 << (@size - (idx + 1))
            n_at_pos = (mask & r) >> (@size - (idx + 1))
            local_counts[n_at_pos] += 1
          end
          bigger = local_counts[1]
          bigger_idx = 1
          (MAX_COUNT).times do |jdx|
            if (bigger < local_counts[jdx])
              bigger = local_counts[jdx]
              bigger_idx = jdx
            end
          end
          possible_ratings.select! do |r|
            mask = 1_i64 << (@size - (idx + 1))
            n_at_pos = (mask & r) >> (@size - (idx + 1))
            n_at_pos == bigger_idx
          end
          break if possible_ratings.size == 1
        end
        raise "oh no" if possible_ratings.size > 1 || possible_ratings.size == 0
        possible_ratings.first
      end
    end

    def co2_scrubber_rating
      @co2_scrubber_rating || begin
        possible_ratings = @inputs.dup
        @size.times do |idx|
          local_counts = Array(Int64).new(MAX_COUNT + 1, 0)
          possible_ratings.each do |r|
            mask = 1_i64 << (@size - (idx + 1))
            n_at_pos = (mask & r) >> (@size - (idx + 1))
            local_counts[n_at_pos] += 1
          end
          bigger = local_counts[0]
          bigger_idx = 0
          (MAX_COUNT).times do |jdx|
            jdx += 1
            if (bigger > local_counts[jdx])
              bigger = local_counts[jdx]
              bigger_idx = jdx
            end
          end
          possible_ratings.select! do |r|
            mask = 1_i64 << (@size - (idx + 1))
            n_at_pos = (mask & r) >> (@size - (idx + 1))
            n_at_pos == bigger_idx
          end
          break if possible_ratings.size == 1
        end
        raise "oh no" if possible_ratings.size > 1 || possible_ratings.size == 0
        possible_ratings.first
      end
    end

    def power_consumption
      epsilon_rate * gamma_rate
    end

    def life_support_rating
      co2_scrubber_rating * oxygen_gen_rating
    end
  end

  def self.part_1()
    sub_diag = SubmarineDiagnostics.new(12_i64)

    while (instruction = gets)
      sub_diag.read_report(instruction)
    end

    puts sub_diag.power_consumption
    puts sub_diag.life_support_rating
  end
end
