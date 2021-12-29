require "./spec_helper"

describe Day23 do
  # TODO: Write tests

  describe "unit tests" do
    it "tests the first row to hallway function" do
      ao = Day23::AmphipodOrganizer.new
      hallway = ['.', 'B', '.', '.', '.', '.', '.', '.', '.', '.', '.']
      first_row = {'.', 'C', 'B', 'D'}
      ao.can_move_from_first_row_to_hallway?(0, hallway, 2, first_row).should eq(nil)
      ao.can_move_from_first_row_to_hallway?(4, hallway, 2, first_row).should eq(nil)
      ao.can_move_from_first_row_to_hallway?(2, hallway, 2, first_row).should eq(nil)
      ao.can_move_from_first_row_to_hallway?(5, hallway, 2, first_row).should eq(20)
      ao.can_move_from_first_row_to_hallway?(3, hallway, 2, first_row).should eq(40)
      ao.can_move_from_first_row_to_hallway?(7, hallway, 3, first_row).should eq(2000)
    end

    it "tests the second row to hallway function" do
      ao = Day23::AmphipodOrganizer.new
      hallway = ['.', 'B', '.', '.', '.', '.', '.', '.', '.', '.', '.']
      second_row = {'.', 'C', 'B', 'D'}
      ao.can_move_from_nth_row_to_hallway?(2, 0, hallway, 2, second_row).should eq(nil)
      ao.can_move_from_nth_row_to_hallway?(2, 5, hallway, 2, second_row).should eq(30)
      ao.can_move_from_nth_row_to_hallway?(2, 3, hallway, 2, second_row).should eq(50)
      ao.can_move_from_nth_row_to_hallway?(2, 7, hallway, 3, second_row).should eq(3000)
      ao.can_move_from_nth_row_to_hallway?(3, 7, hallway, 3, second_row).should eq(4000)
      ao.can_move_from_nth_row_to_hallway?(4, 7, hallway, 3, second_row).should eq(5000)
    end

    it "tests the hallway to first row function" do
      ao = Day23::AmphipodOrganizer.new
      hallway = ['.', 'B', 'C', '.', '.', '.', '.', 'A', '.', '.', '.']
      first_row = {'.', 'C', 'B', 'D'}
      ao.can_move_from_hallway_to_first_row?(1, hallway, first_row).should eq(nil)
      ao.can_move_from_hallway_to_first_row?(7, hallway, first_row).should eq(nil)
      hallway = ['.', 'B', '.', '.', '.', '.', '.', 'A', '.', '.', '.']
      ao.can_move_from_hallway_to_first_row?(7, hallway, first_row).should eq(6)
    end

    it "tests the hallway to nth row function" do
      ao = Day23::AmphipodOrganizer.new
      hallway = ['.', 'B', 'C', '.', '.', '.', '.', 'A', '.', '.', '.']
      row = {'.', 'C', 'B', 'D'}
      ao.can_move_from_hallway_to_nth_row?(2, 1, hallway, row).should eq(nil)
      ao.can_move_from_hallway_to_nth_row?(2, 7, hallway, row).should eq(nil)
      hallway = ['.', 'B', '.', '.', '.', '.', '.', 'A', '.', '.', '.']
      ao.can_move_from_hallway_to_nth_row?(2, 7, hallway, row).should eq(7)
      ao.can_move_from_hallway_to_nth_row?(3, 7, hallway, row).should eq(8)
      ao.can_move_from_hallway_to_nth_row?(4, 7, hallway, row).should eq(9)
    end
  end

  describe "Reading the map" do
    it "tests that the map is read correctly" do
      sample_input = ["#############",
"#...........#",
"###B#C#B#D###",
"  #A#D#C#A#",
"  #########"]

      expected_state = ["#############",
"#...........#",
"###B#C#B#D###",
"###A#D#C#A###",
"#############"]

      expected_map = ["#############",
"#...........#",
"###A#B#C#D###",
"###A#B#C#D###",
"#############"]

      ao = Day23::AmphipodOrganizer.new
      sample_input.each do |line|
        ao.read_line(line)
      end
      ao.current_state.should eq(expected_state)
      ao.rooms_map.should eq(expected_map)
    end
  end

  describe "Test calculating the best path" do
    it "With the sample input, should use 12521 of energy" do
      sample_input = ["#############",
"#...........#",
"###B#C#B#D###",
"  #A#D#C#A#",
"  #########"]

      ao = Day23::AmphipodOrganizer.new
      sample_input.each do |line|
        ao.read_line(line)
      end

      ao.organize.should eq(12521)
    end
    it "With the unfolded sample input, should use 44169 of energy" do
      sample_input = ["#############",
"#...........#",
"###B#C#B#D###",
"  #A#D#C#A#",
"  #########"]

      ao = Day23::AmphipodOrganizer.new(false)
      sample_input.each do |line|
        ao.read_line(line)
      end

      ao.organize.should eq(44169)
    end
  end
end
