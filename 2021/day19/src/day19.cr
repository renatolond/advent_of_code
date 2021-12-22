# TODO: Write documentation for `Day19`
module Day19
  VERSION = "0.1.0"
  class ScannerMap
    def initialize(id = 0)
      @id = id
      @possible_orientations = [] of Array(Tuple(Int64, Int64, Int64, String, String, String))
      @beacon_list = [] of Tuple(Int64, Int64, Int64)
    end

    getter id, beacon_list

    def possible_orientations : Array(Array(Tuple(Int64, Int64, Int64, String, String, String)))
      return @possible_orientations unless @possible_orientations.empty?

      @beacon_list = @beacon_list.sort
      arr = Array(Array(Tuple(Int64, Int64, Int64, String, String, String))).new(24) { [] of Tuple(Int64, Int64, Int64, String, String, String) }
      @beacon_list.each do |beacon|
        x = beacon[0]
        y = beacon[1]
        z = beacon[2]
        # Orientations painstakefully calculated using https://c3d.libretexts.org/CalcPlot3D/index.html
        arr[0] <<  Tuple.new( x,  y,  z,  "x",  "y",  "z")
        arr[1] <<  Tuple.new( x,  z, -y,  "x",  "z", "-y")
        arr[2] <<  Tuple.new( x, -y, -z,  "x", "-y", "-z")
        arr[3] <<  Tuple.new( x, -z,  y,  "x", "-z",  "y")
        arr[4] <<  Tuple.new(-x, -y,  z, "-x", "-y",  "z")
        arr[5] <<  Tuple.new(-x,  y, -z, "-x",  "y", "-z")
        arr[6] <<  Tuple.new(-x,  z,  y, "-x",  "z",  "y")
        arr[7] <<  Tuple.new(-x, -z, -y, "-x", "-z", "-y")
        arr[8] <<  Tuple.new( y,  z,  x,  "y",  "z",  "x")
        arr[9] <<  Tuple.new( y, -x,  z,  "y", "-x",  "z")
        arr[10] << Tuple.new( y,  x, -z,  "y",  "x", "-z")
        arr[11] << Tuple.new( y, -z, -x,  "y", "-z", "-x")
        arr[12] << Tuple.new(-y,  z, -x, "-y",  "z", "-x")
        arr[13] << Tuple.new(-y, -x, -z, "-y", "-x", "-z")
        arr[14] << Tuple.new(-y, -z,  x, "-y", "-z",  "x")
        arr[15] << Tuple.new(-y,  x,  z, "-y",  "x",  "z")
        arr[16] << Tuple.new( z, -x, -y,  "z", "-x", "-y")
        arr[17] << Tuple.new( z, -y,  x,  "z", "-y",  "x")
        arr[18] << Tuple.new( z,  x,  y,  "z",  "x",  "y")
        arr[19] << Tuple.new( z,  y, -x,  "z",  "y", "-x")
        arr[20] << Tuple.new(-z,  x, -y, "-z",  "x", "-y")
        arr[21] << Tuple.new(-z, -y, -x, "-z", "-y", "-x")
        arr[22] << Tuple.new(-z, -x,  y, "-z", "-x",  "y")
        arr[23] << Tuple.new(-z,  y,  x, "-z",  "y",  "x")
      end
      arr.each do |a|
        @possible_orientations << a.sort
      end
      @possible_orientations
      @possible_orientations = @possible_orientations.sort
    end

    def use_orientation(orientation : Array(Tuple(Int64, Int64, Int64, String, String, String)))
      @beacon_list = orientation.map { |v| {v[0], v[1], v[2] } }
    end

    def transform_beacons(dist : Tuple(Int64, Int64, Int64))
      @beacon_list.map! do |b|
        { dist[0] + b[0], dist[1] + b[1], dist[2] + b[2] }
      end
    end

    def read_beacon(line)
      x, y, z = line.split(",").map(&.to_i64)
      @beacon_list << Tuple.new(x, y, z)
    end

    def match(other) : Tuple(Bool, Tuple(Int64, Int64, Int64)?)
      idx = 0
      other.possible_orientations.each do |orientation|
        @beacon_list.each do |my_beacon|
          orientation.each do |other_beacon|
            possible_x_dist = my_beacon[0] - other_beacon[0]
            possible_y_dist = my_beacon[1] - other_beacon[1]
            possible_z_dist = my_beacon[2] - other_beacon[2]
            matching_beacons = 1
            orientation.each do |beacon_in_orient|
              next if beacon_in_orient == other_beacon

              transformed_beacon = { beacon_in_orient[0] + possible_x_dist, beacon_in_orient[1] + possible_y_dist, beacon_in_orient[2] + possible_z_dist }
              if @beacon_list.find { |v| v == transformed_beacon }
                matching_beacons +=  1
              end
              if matching_beacons == 12
                other.use_orientation(orientation)
                return true, {possible_x_dist, possible_y_dist, possible_z_dist}
              end
            end
          end
        end
        idx += 1
      end
      return false, nil
    end
  end

  class ScannerMatcher
    def initialize
      @scanners = [] of ScannerMap
      @current_scanner = ScannerMap.new
      @beacon_list = [] of Tuple(Int64, Int64, Int64)
      @biggest_manhattan = -9999_i64
    end

    getter beacon_list, biggest_manhattan

    def read_line(line)
      if line == ""
        @scanners << @current_scanner
        @current_scanner = ScannerMap.new(@scanners.size)
      elsif line.starts_with?("---")
        puts line
      else
        @current_scanner.read_beacon(line)
      end
    end

    def match!
      @scanners << @current_scanner
      matched = Array(Bool).new(@scanners.size, false)
      @beacon_list = @scanners[0].beacon_list.dup
      current_ids = [0]
      matched[0] = true
      distance_to_zero = Array(Tuple(Int64, Int64, Int64)?).new(@scanners.size, nil)
      distance_to_zero[0] = {0_i64, 0_i64, 0_i64}
      9999.times do
        # TODO change to while matched has false elemements above
        new_ids = [] of Int32
        current_ids.each do |idx|
          a = @scanners[idx]
          @scanners.size.times do |jdx|
            next if jdx == idx
            next if matched[jdx]
            b = @scanners[jdx]
            match, distance_vector = a.match(b)
            if match && distance_vector
              prev_dist_to_zero = distance_to_zero[idx]
              raise "bugger" unless prev_dist_to_zero
              # puts "#{a.id}, #{b.id}: #{distance_vector} - #{prev_dist_to_zero}"
              dist_x = distance_vector[0]
              dist_y = distance_vector[1]
              dist_z = distance_vector[2]
              distance_to_zero[jdx] = {dist_x, dist_y, dist_z}
              b.transform_beacons({dist_x, dist_y, dist_z})
              @beacon_list += b.beacon_list
              matched[jdx] = true
              new_ids << jdx
            end
          end
        end
        current_ids = new_ids
        break if new_ids.empty?
      end
      distance_to_zero.each_permutation(2) do |v|
        a, b = v
        raise "h no" unless a && b
        # puts "#{a}, #{b}"
        manhattan = (a[0] - b[0]).abs + (a[1] - b[1]).abs + (a[2] - b[2]).abs
        @biggest_manhattan = manhattan if manhattan > @biggest_manhattan
      end
      @beacon_list.uniq!
    end
  end

  def self.part_1()
    smtchr = Day19::ScannerMatcher.new
    while (line = gets())
      smtchr.read_line(line)
    end
    smtchr.match!
    puts smtchr.beacon_list.size
  end

  def self.part_2()
    smtchr = Day19::ScannerMatcher.new
    while (line = gets())
      smtchr.read_line(line)
    end
    smtchr.match!
    puts smtchr.biggest_manhattan
  end
end
