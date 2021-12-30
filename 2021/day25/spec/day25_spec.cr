require "./spec_helper"

describe Day25 do
  # TODO: Write tests

  describe "Tests the sea cucumber simulator" do
    it "checks that horizontal movements are working" do
      sample_input = %w[...>>>>>...]
      expected_map_after_1st_step = %w[...>>>>.>..]
      expected_map_after_2nd_step = %w[...>>>.>.>.]

      scs = Day25::SeaCucumberSimulator.new
      sample_input.each do |line|
        scs.read_line(line)
      end

      scs.step
      scs.cucumber_map.should eq(expected_map_after_1st_step)
      scs.step
      scs.cucumber_map.should eq(expected_map_after_2nd_step)
    end

    it "checks that vertical movements are working" do
      sample_input = %w[.
.
.
v
v
v
v
v
.
.
.]
      expected_map_after_1st_step = %w[.
.
.
v
v
v
v
.
v
.
.]
      expected_map_after_2nd_step = %w[.
.
.
v
v
v
.
v
.
v
.]
      scs = Day25::SeaCucumberSimulator.new
      sample_input.each do |line|
        scs.read_line(line)
      end

      scs.step
      scs.cucumber_map.should eq(expected_map_after_1st_step)
      scs.step
      scs.cucumber_map.should eq(expected_map_after_2nd_step)
    end

    it "Checks that simulation is good and ends at the correct step" do
      sample_input = %w[...>...
.......
......>
v.....>
......>
.......
..vvv..]
      expected_map_after_1st_step = %w[..vv>..
.......
>......
v.....>
>......
.......
....v..]

      expected_map_after_2nd_step = %w[....v>.
..vv...
.>.....
......>
v>.....
.......
.......]
      expected_map_after_3rd_step = %w[......>
..v.v..
..>v...
>......
..>....
v......
.......]
      expected_map_after_4th_step = %w[>......
..v....
..>.v..
.>.v...
...>...
.......
v......
]

      scs = Day25::SeaCucumberSimulator.new
      sample_input.each do |line|
        scs.read_line(line)
      end

      scs.step
      scs.cucumber_map.should eq(expected_map_after_1st_step)
      scs.step
      scs.cucumber_map.should eq(expected_map_after_2nd_step)
      scs.step
      scs.cucumber_map.should eq(expected_map_after_3rd_step)
      scs.step
      scs.cucumber_map.should eq(expected_map_after_4th_step)
    end
  end

  it "checks that the simulator stops when no more movements is detected" do
      sample_input = %w[v...>>.vv>
.vv>>.vv..
>>.>v>...v
>>v>>.>.v.
v>v.vv.v..
>.>>..v...
.vv..>.>v.
v.v..>>v.v
....v..v.>]
      expected_output = %w[..>>v>vv..
..v.>>vv..
..>>v>>vv.
..>>>>>vv.
v......>vv
v>v....>>v
vvv.....>>
>vv......>
.>v.vv.v..]

      scs = Day25::SeaCucumberSimulator.new
      sample_input.each do |line|
        scs.read_line(line)
      end

      scs.step_until_no_movements
      scs.steps.should eq(58)
      scs.cucumber_map.should eq(expected_output)
  end
end
