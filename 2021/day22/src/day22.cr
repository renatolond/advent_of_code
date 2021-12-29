# TODO: Write documentation for `Day22`
module Day22
  VERSION = "0.1.0"

  class NaiveCuboidSimulator
    def initialize(booting = true)
      @on_cuboid_list = Set(Tuple(Int64, Int64, Int64)).new
      @booting = booting
    end

    def read_instruction(line)
      instruction, xyz = line.split(" ", 2)
      xs, ys, zs = line.split(",", 3)
      x1, x2 = xs.split("=", 2).last.split("..").map(&.to_i64)
      y1, y2 = ys.split("=", 2).last.split("..").map(&.to_i64)
      z1, z2 = zs.split("=", 2).last.split("..").map(&.to_i64)
      if @booting
        x1 = -50_i64 if x1 < -50
        x2 = 50_i64 if x2 > 50
        y1 = -50_i64 if y1 < -50
        y2 = 50_i64 if y2 > 50
        z1 = -50_i64 if z1 < -50
        z2 = 50_i64 if z2 > 50
      end
      (x1..x2).each do |x|
        (y1..y2).each do |y|
          (z1..z2).each do |z|
            pos = {x, y, z}
            if instruction == "on"
              @on_cuboid_list.add(pos)
            else
              @on_cuboid_list.delete(pos)
            end
          end
        end
      end
    end

    def on_cuboids
      @on_cuboid_list.size
    end
  end

  struct Cuboid
    property xs
    property ys
    property zs

    def initialize(@xs : Range(Int64, Int64), @ys : Range(Int64, Int64), @zs : Range(Int64, Int64))
    end

    def intersect(other : self) : self
      new_xs = ([@xs.begin, other.xs.begin].max..[@xs.end, other.xs.end].min)
      new_ys = ([@ys.begin, other.ys.begin].max..[@ys.end, other.ys.end].min)
      new_zs = ([@zs.begin, other.zs.begin].max..[@zs.end, other.zs.end].min)
      Cuboid.new(new_xs, new_ys, new_zs)
    end

    def volume
      return 0 if @xs.end < @xs.begin ||
        @ys.end < @ys.begin ||
        @zs.end < @zs.begin

      (@xs.end - @xs.begin) * (@ys.end - @ys.begin) * (@zs.end - @zs.begin)
    end
  end
  class CuboidSimulator
    def initialize(booting = true)
      @instructions = [] of Tuple(Bool, Cuboid)
      @booting = booting
    end

    getter instructions

    def read_instruction(line)
      instruction, xyz = line.split(" ", 2)
      xs, ys, zs = line.split(",", 3)
      x1, x2 = xs.split("=", 2).last.split("..").map(&.to_i64)
      y1, y2 = ys.split("=", 2).last.split("..").map(&.to_i64)
      z1, z2 = zs.split("=", 2).last.split("..").map(&.to_i64)
      if @booting
        x1 = [[-50_i64, x1].max, 50_i64].min
        x2 = [[-50_i64, x2].max, 50_i64].min
        y1 = [[-50_i64, y1].max, 50_i64].min
        y2 = [[-50_i64, y2].max, 50_i64].min
        z1 = [[-50_i64, z1].max, 50_i64].min
        z2 = [[-50_i64, z2].max, 50_i64].min
      end
      @instructions << {instruction == "on", Cuboid.new((x1..x2+1), (y1..y2+1), (z1..z2+1))}
    end

    def volume_differential(cuboid : Cuboid, more_cuboids : Array(Cuboid))
      intersecting = [] of Cuboid
      more_cuboids.each do |other_cuboid|
        intersect = cuboid.intersect(other_cuboid)
        next if intersect.volume == 0
        intersecting << intersect
      end
      volume = cuboid.volume
      intersecting.each_with_index do |intersect, idx|
        volume -= volume_differential(intersect, intersecting[idx+1..])
      end

      volume
    end

    def on_cuboids
      on_cuboid_count = 0_i64
      @instructions.each_with_index do |instruction, idx|
        on_cuboid_count += volume_differential(instruction[1], @instructions[idx+1..].map { |i| i[1]}) if instruction[0]
      end

      on_cuboid_count
    end
  end

  def self.part_1()
    cs = Day22::NaiveCuboidSimulator.new
    while (line = gets())
      cs.read_instruction(line)
    end
    puts cs.on_cuboids
  end

  def self.part_2()
    cs = Day22::CuboidSimulator.new(false)
    while (line = gets())
      cs.read_instruction(line)
    end
    puts cs.on_cuboids
  end
end
