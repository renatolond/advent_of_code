# TODO: Write documentation for `Day21`
module Day21
  VERSION = "0.1.0"

  class DeterministicDice
    @current_roll = 0
    def roll
      res = @current_roll + 1
      @current_roll = (@current_roll + 1) % 100
      res
    end
  end

  class DeterministicDiracDice
    def initialize
      @dice = DeterministicDice.new
      @die_rolls = 0
      @players_position = [] of Int32
      @players_points = [] of Int64
      @finished = false
    end

    def setup_player(line)
      words = line.split(" ")
      player = words[1].to_i32
      position = words[4].to_i32 - 1
      @players_position << position
      raise "oh no" if @players_position[player - 1] != position
      @players_points << 0
    end

    def play_a_turn
      @players_position.size.times do |idx|
        walk_around = 0
        3.times do
          walk_around += @dice.roll
          @die_rolls += 1
        end
        walk_around = (walk_around + @players_position[idx]) % 10
        @players_position[idx] = walk_around
        @players_points[idx] += walk_around + 1
        if @players_points[idx] >= 1000
          @finished = true
          return
        end
      end
    end

    def play!
      while !@finished
        play_a_turn
      end
    end

    def formula
      @die_rolls * @players_points.min
    end
  end

  class DiracDice < DeterministicDiracDice
    def initialize
      super()
      @wins = [] of Int64
    end

    getter wins

    def wins
      @wins
    end

    def setup_player(line)
      super
      @wins << 0_i64
    end

    DICE_TIMES = [1, 3, 6, 7, 6, 3, 1] # [3, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 8, 8, 8, 9]
    def split_universe(player1_points, player2_points, player1_pos, player2_pos, whose_turn = 1)
      wins = [0_i64, 0_i64]
      7.times do |idx|
        rolled = 3 + (idx) # between 3 and 9
        p1_pos = player1_pos
        p2_pos = player2_pos
        p1_points = player1_points
        p2_points = player2_points
        l_whose_turn = whose_turn
        if l_whose_turn == 1
          p1_pos = (p1_pos + rolled) % 10
          p1_points += p1_pos + 1
          l_whose_turn = 2
        else
          p2_pos = (p2_pos + rolled) % 10
          p2_points += p2_pos + 1
          l_whose_turn = 1
        end
        if p1_points >= 21 || p2_points >= 21
          if p1_points > p2_points
            wins[0] += DICE_TIMES[idx]
          else
            wins[1] += DICE_TIMES[idx]
          end
        else
          other_universes_wins = split_universe(p1_points, p2_points, p1_pos, p2_pos, l_whose_turn)
          2.times do |jdx|
            wins[jdx] += other_universes_wins[jdx] * DICE_TIMES[idx]
          end
        end
      end
      wins
    end

    def play!
      other_universes_wins = split_universe(0, 0, @players_position[0], @players_position[1], 1)
      2.times do |idx|
        @wins[idx] += other_universes_wins[idx]
      end
    end
  end

  def self.part_1()
    dice_game = Day21::DeterministicDiracDice.new
    while (line = gets())
      dice_game.setup_player(line)
    end
    dice_game.play!
    puts dice_game.formula
  end

  def self.part_2()
    dice_game = Day21::DiracDice.new
    while (line = gets())
      dice_game.setup_player(line)
    end
    dice_game.play!
    puts dice_game.wins
  end
end
