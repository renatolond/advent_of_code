require "./spec_helper"

describe Day11 do
  # TODO: Write tests

  it "with sample input, there should be 1656 flashes" do
    sample_input = %w[5483143223
2745854711
5264556173
6141336146
6357385478
4167524645
2176841721
6882881134
4846848554
5283751526]
    expected_after_1st_step = %w[6594254334
3856965822
6375667284
7252447257
7468496589
5278635756
3287952832
7993992245
5957959665
6394862637
]
    expected_after_2nd_step = %w[8807476555
5089087054
8597889608
8485769600
8700908800
6600088989
6800005943
0000007456
9000000876
8700006848]
    expected_after_10th_step = %w[0481112976
0031112009
0041112504
0081111406
0099111306
0093511233
0442361130
5532252350
0532250600
0032240000]
    expected_after_100th_step = %w[0397666866
0749766918
0053976933
0004297822
0004229892
0053222877
0532222966
9322228966
7922286866
6789998766]
    ofd = Day11::OctopusFlashDetector.new

    sample_input.each do |line|
      ofd.read(line)
    end
    ofd.step
    ofd.octopuses_energy_readings.should eq(expected_after_1st_step)
    ofd.step

    ofd.octopuses_energy_readings.should eq(expected_after_2nd_step)
    (10 - 2).times do
      ofd.step
    end

    ofd.flash_count.should eq(204)
    ofd.octopuses_energy_readings.should eq(expected_after_10th_step)

    (100 - 10).times do
      ofd.step
    end
    ofd.flash_count.should eq(1656)
    ofd.octopuses_energy_readings.should eq(expected_after_100th_step)

    step = 101
    loop do
      ofd.step
      break if ofd.full_flash
      step += 1
    end
    step.should eq(195)
  end

  it "with some 9 in the input, there should be 9 flashes" do
    sample_input = %w[11111
19991
19191
19991
11111]

    expected_after_1st_step = %w[34543
40004
50005
40004
34543]
    expected_after_2nd_step = %w[45654
51115
61116
51115
45654]
    ofd = Day11::OctopusFlashDetector.new

    sample_input.each do |line|
      ofd.read(line)
    end

    ofd.step

    ofd.flash_count.should eq(9)
    ofd.octopuses_energy_readings.should eq(expected_after_1st_step)

    ofd.step

    ofd.flash_count.should eq(9)
    ofd.octopuses_energy_readings.should eq(expected_after_2nd_step)
  end
end
