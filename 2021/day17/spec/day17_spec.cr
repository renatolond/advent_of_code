require "./spec_helper"

describe Day17 do
  # TODO: Write tests

  it "with sample input, maximum y should be 45" do
    sample_input = "target area: x=20..30, y=-10..-5"
    pls = Day17::ProbeLaunchSimulator.new(sample_input)
    pls.simulate
    pls.max_y_reached.should eq(45)
    pls.distinct_velocities.should eq(112)
  end
end
