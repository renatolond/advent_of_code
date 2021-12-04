require "./spec_helper"

describe Day4 do
  # TODO: Write tests

  it "with the sample input, score is 4512" do
    sample_input = "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1"
    sample_boards = [["22 13 17 11  0", " 8  2 23  4 24", "21  9 14 16  7", " 6 10  3 18  5", " 1 12 20 15 19"],
                     [" 3 15  0  2 22", " 9 18 13 17  5", "19  8  7 25 23", "20 11 10 24  4", "14 21 16 12  6"],
                     ["14 21 17 24  4", "10 16 15  9 19", "18  8 23 26 20", "22 11 13  6  5", " 2  0 12  3  7"]]

    bingo_system = Day4::BingoSystem.new
    bingo_system.numbers = sample_input

    sample_boards.each do |sample_board|
      bingo_system.add_board(sample_board)
    end

    bingo_system.start_game

    bingo_system.curr_number.should eq(24)
    bingo_system.score.should eq(4512)
  end

  it "with the sample input transposed, score is 4512" do
    sample_input = "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1"
    sample_boards = [["22 13 17 11  0", " 8  2 23  4 24", "21  9 14 16  7", " 6 10  3 18  5", " 1 12 20 15 19"],
                     [" 3 15  0  2 22", " 9 18 13 17  5", "19  8  7 25 23", "20 11 10 24  4", "14 21 16 12  6"],
                     ["14 10 18 22 2", "21 16 8 11 0", "17 15 23 13 12", "24 9 26 6 3", "4 19 20 5 7"]]

    bingo_system = Day4::BingoSystem.new
    bingo_system.numbers = sample_input

    sample_boards.each do |sample_board|
      bingo_system.add_board(sample_board)
    end

    bingo_system.start_game

    bingo_system.curr_number.should eq(24)
    bingo_system.score.should eq(4512)
  end
  it "with the sample input in alt method, score is 1924" do
    sample_input = "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1"
    sample_boards = [["22 13 17 11  0", " 8  2 23  4 24", "21  9 14 16  7", " 6 10  3 18  5", " 1 12 20 15 19"],
                     [" 3 15  0  2 22", " 9 18 13 17  5", "19  8  7 25 23", "20 11 10 24  4", "14 21 16 12  6"],
                     ["14 21 17 24  4", "10 16 15  9 19", "18  8 23 26 20", "22 11 13  6  5", " 2  0 12  3  7"]]

    bingo_system = Day4::BingoSystem.new
    bingo_system.numbers = sample_input

    sample_boards.each do |sample_board|
      bingo_system.add_board(sample_board)
    end

    bingo_system.start_game_alt

    bingo_system.curr_number.should eq(13)
    bingo_system.score.should eq(1924)
  end
end
