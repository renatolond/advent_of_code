require "./spec_helper"

describe Day13 do
  # TODO: Write tests

  it "with sample input 1, there should be 10 paths" do
    sample_input = ["6,10",
"0,14",
"9,10",
"0,3",
"10,4",
"4,11",
"6,0",
"6,12",
"4,1",
"0,13",
"10,12",
"3,4",
"3,0",
"8,4",
"1,10",
"2,14",
"8,10",
"9,0",
"",
"fold along y=7",
"fold along x=5"]

    board_after_folds = [%w[#.##..#..#.
#...#......
......#...#
#...#......
.#.#..#.###
...........
...........],
    %w[#####
#...#
#...#
#...#
#####
.....
.....]]
    visible_after_fold = [17, 16]

    ofold = Day13::OrigamiFolder.new
    reading_coords = true
    idx = 0
    sample_input.each do |line|
      if line.empty?
        reading_coords = false
        ofold.print_board
        next
      end
      if reading_coords
        ofold.add_point(line)
      else
        ofold.instruction(line)
        ofold.print_board.should eq(board_after_folds[idx])
        ofold.visible.should eq(visible_after_fold[idx])
        idx += 1
      end
    end
  end
end
