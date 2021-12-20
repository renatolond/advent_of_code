require "./spec_helper"

describe Day18 do
  # TODO: Write tests

  describe "Tests the magnitude from a snailfish number" do
    it "From the simple example gets 29" do
      sn = Day18::SnailfishNumber.new(9, 1)
      sn.magnitude.should eq(29)
    end

    it "Tests recursion and gets 129" do
      sn = Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(9, 1), Day18::SnailfishNumber.new(1, 9))
      sn.magnitude.should eq(129)
    end
  end

  describe "equality operator" do
    it "checks that two snailfish numbers are the same" do
      Day18::SnailfishNumber.new(9, 1).should eq(Day18::SnailfishNumber.new(9, 1))
    end
    it "checks that two snailfish numbers are different" do
      Day18::SnailfishNumber.new(9, 1).should_not eq(Day18::SnailfishNumber.new(9, 2))
    end
  end

  describe "tests adding two snailfish numbers" do
    it "tests adding two numbers that don't need reducing" do
      n1 = Day18::SnailfishNumber.new(1, 1)
      n2 = Day18::SnailfishNumber.new(2, 2)

      expected_n = Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(1, 1), Day18::SnailfishNumber.new(2, 2))

      (n1 + n2).should eq(expected_n)
    end
  end

  describe "tests reduction rules" do
    it "splits the left side" do
      n1 = Day18::SnailfishNumber.new(15, 1)
      expected_n = Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(7, 8), 1)

      n1.reduce.should eq(expected_n)
    end
    it "splits the right side" do
      n1 = Day18::SnailfishNumber.new(1, 15)
      expected_n = Day18::SnailfishNumber.new(1, Day18::SnailfishNumber.new(7, 8))

      n1.reduce.should eq(expected_n)
    end
    it "splits the leftmost side" do
      n1 = Day18::SnailfishNumber.new(15, Day18::SnailfishNumber.new(1, 15))
      expected_n = Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(7, 8), Day18::SnailfishNumber.new(1, Day18::SnailfishNumber.new(7, 8)))

      n1.reduce.should eq(expected_n)
    end
    it "explode case 1: no number to the left" do
      n = Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(9, 8), 1), 2), 3), 4)
      expected_n = Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(0, 9), 2), 3), 4)
      n.reduce.should eq(expected_n)
    end
    it "explode case 2: no number to the right" do
      n = Day18::SnailfishNumber.new(7, Day18::SnailfishNumber.new(6, Day18::SnailfishNumber.new(5, Day18::SnailfishNumber.new(4, Day18::SnailfishNumber.new(3, 2)))))
      expected_n = Day18::SnailfishNumber.new(7, Day18::SnailfishNumber.new(6, Day18::SnailfishNumber.new(5, Day18::SnailfishNumber.new(7, 0))))
      n.reduce.should eq(expected_n)
    end
    it "explode case 3: explodes in the middle of the tree" do
      n = Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(6, Day18::SnailfishNumber.new(5, Day18::SnailfishNumber.new(4, Day18::SnailfishNumber.new(3, 2)))), 1)
      expected_n = Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(6, Day18::SnailfishNumber.new(5, Day18::SnailfishNumber.new(7, 0))), 3)
      n.reduce.should eq(expected_n)
    end
    it "explode case 4: double explodes in the middle of the tree" do
      n = Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(3, Day18::SnailfishNumber.new(2, Day18::SnailfishNumber.new(1, Day18::SnailfishNumber.new(7, 3)))), Day18::SnailfishNumber.new(6, Day18::SnailfishNumber.new(5, Day18::SnailfishNumber.new(4, Day18::SnailfishNumber.new(3, 2)))))
      expected_n = Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(3, Day18::SnailfishNumber.new(2, Day18::SnailfishNumber.new(8, 0))), Day18::SnailfishNumber.new(9, Day18::SnailfishNumber.new(5, Day18::SnailfishNumber.new(7, 0))))
      n.reduce.should eq(expected_n)
    end

    it "mixes splits and explodes" do
      n = Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(4, 3), 4), 4), Day18::SnailfishNumber.new(7, Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(8, 4), 9))),Day18::SnailfishNumber.new(1, 1))

      expected_n = Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(0, 7), 4), Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(7, 8), Day18::SnailfishNumber.new(6, 0))), Day18::SnailfishNumber.new(8, 1))
      n.reduce.should eq(expected_n)
    end
  end

  describe "test the reader" do
    expected_n = Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(0, 7), 4), Day18::SnailfishNumber.new(Day18::SnailfishNumber.new(7, 8), Day18::SnailfishNumber.new(6, 0))), Day18::SnailfishNumber.new(8, 1))
    Day18::SnailfishNumber.read("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]").should eq(expected_n)
  end

  describe "test actual sums!" do
    it "tests first simple sum" do
      sample_input = ["[1,1]",
                      "[2,2]",
                      "[3,3]",
                      "[4,4]",
                      "[5,5]"]
      current_snailfish = nil
      sample_input.each do |line|
        to_add = Day18::SnailfishNumber.read(line)
        to_add.inspect.should eq(line)
        if current_snailfish
          current_snailfish = current_snailfish + to_add
        else
          current_snailfish = to_add
        end
      end

      raise "oh noes" if current_snailfish.nil?
      current_snailfish.inspect.should eq("[[[[3,0],[5,3]],[4,4]],[5,5]]")
    end

    it "tests second simple sum" do
      sample_input = ["[1,1]",
                      "[2,2]",
                      "[3,3]",
                      "[4,4]",
                      "[5,5]",
                      "[6,6]"]
      current_snailfish = nil
      sample_input.each do |line|
        to_add = Day18::SnailfishNumber.read(line)
        to_add.inspect.should eq(line)
        if current_snailfish
          current_snailfish = current_snailfish + to_add
        else
          current_snailfish = to_add
        end
      end

      raise "oh noes" if current_snailfish.nil?
      current_snailfish.inspect.should eq("[[[[5,0],[7,4]],[5,5]],[6,6]]")
    end

    it "tests first example" do
      sample_input = ["[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]",
                      "[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]",
                      "[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]",
                      "[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]",
                      "[7,[5,[[3,8],[1,4]]]]",
                      "[[2,[2,2]],[8,[8,1]]]",
                      "[2,9]",
                      "[1,[[[9,3],9],[[9,0],[0,7]]]]",
                      "[[[5,[7,4]],7],1]",
                      "[[[[4,2],2],6],[8,7]]"]
      intermediary_sums = ["[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]",
                           "[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]",
                           "[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]",
                           "[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]",
                           "[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]",
                           "[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]",
                           "[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]",
                           "[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]",
                           "[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]",
                           "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]"]

      current_snailfish = nil
      sample_input.each do |line|
        to_add = Day18::SnailfishNumber.read(line)
        to_add.inspect.should eq(line)
        if current_snailfish
          current_snailfish = current_snailfish + to_add
        else
          current_snailfish = to_add
        end
        current_snailfish.inspect.should eq(intermediary_sums.shift)
      end

      raise "oh noes" if current_snailfish.nil?
      current_snailfish.inspect.should eq("[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]")
      current_snailfish.magnitude.should eq(3488)
    end

    it "tests the second example" do
      sample_input = ["[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]",
                      "[[[5,[2,8]],4],[5,[[9,9],0]]]",
                      "[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]",
                      "[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]",
                      "[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]",
                      "[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]",
                      "[[[[5,4],[7,7]],8],[[8,3],8]]",
                      "[[9,3],[[9,9],[6,[4,9]]]]",
                      "[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]",
                      "[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]"]

      current_snailfish = nil
      sample_input.each do |line|
        to_add = Day18::SnailfishNumber.read(line)
        to_add.inspect.should eq(line)
        if current_snailfish
          current_snailfish = current_snailfish + to_add
        else
          current_snailfish = to_add
        end
      end

      raise "oh noes" if current_snailfish.nil?
      current_snailfish.inspect.should eq("[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]")
      current_snailfish.magnitude.should eq(4140)
    end
  end

  describe "XXXX tests part two" do
    it "permutes the snailfish" do
      sample_input = ["[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]",
                      "[[[5,[2,8]],4],[5,[[9,9],0]]]",
                      "[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]",
                      "[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]",
                      "[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]",
                      "[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]",
                      "[[[[5,4],[7,7]],8],[[8,3],8]]",
                      "[[9,3],[[9,9],[6,[4,9]]]]",
                      "[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]",
                      "[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]"]

      all_snailfish = [] of Day18::SnailfishNumber
      bigger_magnitude = -999
      sample_input.each_repeated_permutation(2) do |perm|
        a, b = perm
        next if a == b
        a = Day18::SnailfishNumber.read(a)
        b = Day18::SnailfishNumber.read(b)
        magnitude = (a + b).magnitude
        bigger_magnitude = magnitude if magnitude > bigger_magnitude
      end

      bigger_magnitude.should eq(3993)
    end
  end
end
