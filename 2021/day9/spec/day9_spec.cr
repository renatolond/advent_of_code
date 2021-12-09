require "./spec_helper"

describe Day9 do
  # TODO: Write tests

  it "with the sample input, risk should be 15" do
    sample_input = %w[2199943210
3987894921
9856789892
8767896789
9899965678]
    rm = Day9::RiskMapper.new

    sample_input.each do |line|
      rm.read(line)
    end

    rm.low_points.should eq([1, 0, 5, 5])
    rm.risk_sum.should eq(15)
    rm.basins.should eq([3, 9, 14, 9])
    rm.largest_basins.should eq([9, 9, 14])
    rm.basin_result.should eq(1134)
  end
end
