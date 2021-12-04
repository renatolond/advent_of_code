# TODO: Write documentation for `Day4`
module Day4
  VERSION = "0.1.0"

  class BingoBoard
    @board : Array(Array(Int64))
    @marked : Array(Array(Bool))

    def initialize()
      @board = Array(Array(Int64)).new(5) { Array(Int64).new(5) }
      @marked = Array(Array(Bool)).new(5) { Array(Bool).new(5, false) }
    end

    def initialize_elems(elems)
      idx = 0
      elems.each do |line|
        @board[idx] = line.strip.split(/ +/).map { |el| Int64.new(el) }
        idx += 1
      end
    end

    def mark(number)
      5.times do |idx|
        jdx = @board[idx].index(number)
        @marked[idx][jdx] = true if jdx
      end
    end

    def winner? : Bool
      5.times do |idx|
        return true if @marked[idx].uniq == [true]
      end
      5.times do |jdx|
        winner = true
        5.times do |idx|
          winner &= @marked[idx][jdx]
        end
        return true if winner
      end
      return false
    end

    def score
      score = 0_i64
      5.times do |idx|
        5.times do |jdx|
          score += @board[idx][jdx] unless @marked[idx][jdx]
        end
      end
      score
    end
  end

  class BingoSystem
    @bingo_boards = [] of BingoBoard
    @winner_boards = [] of BingoBoard
    @numbers = [] of Int64
    @winner : Nil | BingoBoard
    @curr_number : Nil | Int64

    def initialize
    end

    def numbers=(line)
      @numbers = line.split(",").map { |s| Int64.new(s) }
    end

    def add_board(board_els)
      bingo_board = BingoBoard.new
      bingo_board.initialize_elems(board_els)
      @bingo_boards << bingo_board
    end

    def start_game
      @winner = nil
      while (@curr_number = draw)
        @bingo_boards.each do |bingo_board|
          bingo_board.mark(@curr_number)
          if bingo_board.winner?
            @winner = bingo_board
            break
          end
        end
        break if @winner
      end
    end

    def start_game_alt
      @winner = nil
      while (@curr_number = draw)
        all_winners = true
        (@bingo_boards - @winner_boards).each do |bingo_board|
          bingo_board.mark(@curr_number)
          if bingo_board.winner?
            @winner = bingo_board
            @winner_boards << bingo_board
          else
            all_winners = false
          end
        end
        @bingo_boards = @bingo_boards - @winner_boards
        break if all_winners
      end
    end

    def winner
      @winner
    end

    def score
      raise "No winner chosen yet" if @winner.nil?

      score = @winner.not_nil!.score * @curr_number.not_nil!
    end

    def curr_number
      @curr_number
    end

    def draw
      @numbers.shift if @numbers.size > 0
    end
  end

  def self.build_bingo_system
    bingo_system = BingoSystem.new

    numbers = gets
    exit(99) if numbers.nil?
    bingo_system.numbers = numbers

    while (empty_line = gets)
      board_lines = [] of String
      5.times do
        line = gets
        exit(99) if line.nil?
        board_lines << line
      end
      bingo_system.add_board(board_lines)
    end
    bingo_system
  end

  def self.part_1()
    bingo_system = build_bingo_system
    bingo_system.start_game
    puts bingo_system.curr_number
    puts bingo_system.score
  end

  def self.part_2()
    bingo_system = build_bingo_system
    bingo_system.start_game_alt
    puts bingo_system.curr_number
    puts bingo_system.score
  end
end
