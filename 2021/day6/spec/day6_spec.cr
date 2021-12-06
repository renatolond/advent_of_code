require "./spec_helper"

describe Day6 do
  # TODO: Write tests

  it "with the sample input, ignoring diagonals, should eq 5" do
    sample_input = "3,4,3,1,2"

    lfs = Day6::LanternFishSimulation.new

    lfs.initial_state(sample_input)

    lfs.fishes.should eq([0, 1, 1, 2, 1, 0, 0, 0, 0])
    lfs.fish_count.should eq(5)

    lfs.simulate
    lfs.fishes.should eq([1, 1, 2, 1, 0, 0, 0, 0, 0])

    lfs.simulate
    lfs.fishes.should eq([1, 2, 1, 0, 0, 0, 1, 0, 1])

    (5 - 2).times do
      lfs.simulate
    end
    lfs.fishes.should eq([0, 0, 0, 1, 1, 3, 2, 2, 1])
    lfs.fish_count.should eq(10)

    (18 - 5).times do
      lfs.simulate
    end
    lfs.fish_count.should eq(26)

    (80 - 18).times do
      lfs.simulate
    end
    lfs.fish_count.should eq(5934)

    (256 - 80).times do
      lfs.simulate
    end

    lfs.fish_count.should eq(26984457539)
  end
end
