# frozen_string_literal: true

module Common
  BOUNDARY_Y = 103
  BOUNDARY_X = 101
  # BOUNDARY_Y = 5
  # BOUNDARY_X = 5
  class Robot
    def initialize(pos_y, pos_x, vel_y, vel_x)
      @y = pos_y.to_i
      @x = pos_x.to_i
      @vel_y = vel_y.to_i
      @vel_x = vel_x.to_i
    end

    def move
      @y += vel_y
      if @y < 0
        @y += BOUNDARY_Y
      elsif @y >= BOUNDARY_Y
        @y -= BOUNDARY_Y
      end
      @x += vel_x
      if @x < 0
        @x += BOUNDARY_X
      elsif @x >= BOUNDARY_X
        @x -= BOUNDARY_X
      end
    end
    attr_accessor :y, :x, :vel_y, :vel_x
  end

  class Simulation
    def initialize
      @robots = []
    end

    def add_robot(pos_y, pos_x, vel_y, vel_x)
      @robots << Robot.new(pos_y, pos_x, vel_y, vel_x)
    end

    def move
      @robots.each { |r| r.move }
    end

    def detect_tree
      split_space = Hash.new(0)
      middle_x = BOUNDARY_X / 2
      robot_count = 0
      @robots.each do |r|
        if r.x < middle_x
          split_space[[r.y, r.x]] += 1
          robot_count = robot_count.succ
        elsif r.x > middle_x
          new_x = ((BOUNDARY_X - 1) - r.x).abs
          next if new_x.negative?

          split_space[[r.y, new_x]] += 1
          robot_count = robot_count.succ
        end
      end
      even = 0
      # pp split_space
      split_space.each_value do |sp|
        next if sp.zero?

        even += sp if sp.even?
      end
      percentage = even / robot_count.to_f
      if percentage >= 0.22
        split_space = Array.new(BOUNDARY_Y) { Array.new(BOUNDARY_X / 2, 0) }
        middle_x = BOUNDARY_X / 2
        @robots.each do |r|
          if r.x < middle_x
            split_space[r.y][r.x] += 1
          elsif r.x > middle_x
            new_x = ((BOUNDARY_X - 1) - r.x).abs
            next if new_x < 0

            split_space[r.y][new_x] += 1
          end
        end
        split_space.each { |s| s.each { |sp| sp == 0 ? print(".") : print("*") }; puts }
      end
      percentage
    end

    def robots(i)
      percentage = detect_tree
      # split_space = Array.new(BOUNDARY_Y) { Array.new(BOUNDARY_X / 2, 0) }
      # middle_x = BOUNDARY_X / 2
      # @robots.each do |r|
      #   if r.x < middle_x
      #     split_space[r.y][r.x] += 1
      #   elsif r.x > middle_x
      #     new_x = ((BOUNDARY_X - 1) - r.x).abs
      #     next if new_x < 0

      #     split_space[r.y][new_x] += 1
      #   end
      # end
      # even = 0
      # split_space.each { |s| s.each { |sp| next if sp.zero?; sp.even? ? even += 1 : nil } }
      # percentage = even / @robots.size.to_f
      pp "#{percentage} -- #{i}" if (i % 1000).zero?
      return false if percentage < 0.22

      # pp even
      space = Array.new(BOUNDARY_Y) { Array.new(BOUNDARY_X, 0) }
      @robots.each { |r| space[r.y][r.x] += 1 }
      puts "===================== #{i} ========================================"
      jdx = 0
      space.each do |s|
        s.each_with_index do |sp, _i|
          # if i == middle_x
          #   print " "
          #   next
          # end
          if sp == 0
            print(".") else
                         print("*")
          end
        end
        puts
        jdx += 1
      end
      #exit(1)
      true
    end

    def count_quadrants
      quadrants = Array.new(4, 0)

      middle_y = BOUNDARY_Y / 2
      middle_x = BOUNDARY_X / 2
      @robots.each do |r|
        if r.x < middle_x && r.y < middle_y
          quadrants[0] += 1
        elsif r.x > middle_x && r.y < middle_y
          quadrants[1] += 1
        elsif r.x > middle_x && r.y > middle_y
          quadrants[2] += 1
        elsif r.x < middle_x && r.y > middle_y
          quadrants[3] += 1
        end
      end
      mul = 1
      quadrants.each { |v| mul *= v }
      mul
    end
  end
  class << self
  end
end
