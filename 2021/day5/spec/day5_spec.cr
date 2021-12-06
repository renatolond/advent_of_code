require "./spec_helper"

describe Day5 do
  # TODO: Write tests

  it "with the sample input, ignoring diagonals, should eq 5" do
    sample_input = ["0,9 -> 5,9",
                    "8,0 -> 0,8",
                    "9,4 -> 3,4",
                    "2,2 -> 2,1",
                    "7,0 -> 7,4",
                    "6,4 -> 2,0",
                    "0,9 -> 2,9",
                    "3,4 -> 1,4",
                    "0,0 -> 8,8",
                    "5,5 -> 8,2"]

    vds = Day5::VentDetectionSystem.new

    sample_input.each do |vent|
      vds.add_vent(vent)
    end

    vds.most_danger_qty.should eq(5)
  end

  it "with the sample input, not ignoring diagonals, should eq 5" do
    sample_input = ["0,9 -> 5,9",
                    "8,0 -> 0,8",
                    "9,4 -> 3,4",
                    "2,2 -> 2,1",
                    "7,0 -> 7,4",
                    "6,4 -> 2,0",
                    "0,9 -> 2,9",
                    "3,4 -> 1,4",
                    "0,0 -> 8,8",
                    "5,5 -> 8,2"]

    vds = Day5::VentDetectionSystem.new(ignore_diagonal: false)

    sample_input.each do |vent|
      vds.add_vent(vent)
    end

    vds.most_danger_qty.should eq(12)
  end

  it "with another input, not ignoring diagonals, should eq 4" do
    sample_input = ["0,0 -> 4,4",
                    "0,4 -> 4,0",
                    "0,0 -> 0,4",
                    "0,0 -> 4,0"]
    vds = Day5::VentDetectionSystem.new(ignore_diagonal: false)

    sample_input.each do |vent|
      vds.add_vent(vent)
    end

    vds.most_danger_qty.should eq(4)
  end
end
