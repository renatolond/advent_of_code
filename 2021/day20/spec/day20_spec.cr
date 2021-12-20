require "./spec_helper"

describe Day20 do
  # TODO: Write tests
  it "tests boundaries" do
    algorithm = "#.#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#"
    input_image = %w[.]

    image_after_1st_enhancement = %w[###
###
###]

    image_after_2nd_enhancement = %w[#####
#####
#####
#####
#####]
    tm = Day20::TrenchMap.new(algorithm)

    input_image.each do |line|
      tm.read_line(line)
    end

    tm.enhance!
    tm.current_image.should eq(image_after_1st_enhancement)

    tm.enhance!
    tm.current_image.should eq(image_after_2nd_enhancement)
  end
  it "test sample input and gets correct number of pixels" do
    algorithm = "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#"
    input_image = %w[#..#.
#....
##..#
..#..
..###]

    image_after_1st_enhancement = %w[.##.##.
#..#.#.
##.#..#
####..#
.#..##.
..##..#
...#.#.]

    image_after_2nd_enhancement = %w[.......#.
.#..#.#..
#.#...###
#...##.#.
#.....#.#
.#.#####.
..#.#####
...##.##.
....###..]

    tm = Day20::TrenchMap.new(algorithm)

    input_image.each do |line|
      tm.read_line(line)
    end

    tm.enhance!
    tm.current_image.should eq(image_after_1st_enhancement)

    tm.enhance!
    tm.current_image.should eq(image_after_2nd_enhancement)

    tm.lit_pixels.should eq(35)

    (50 - 2).times do
      tm.enhance!
    end
    tm.lit_pixels.should eq(3351)
  end
end
