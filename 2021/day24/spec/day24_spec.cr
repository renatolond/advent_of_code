require "./spec_helper"

describe Day24 do
  # TODO: Write tests

  describe "test the ALU" do
    it "it should load the program correctly and test the output" do
      sample_instructions = ["inp x",
                             "mul x -1"]
      alu = Day24::ALU.new
      sample_instructions.each do |line|
        alu.load_instruction(line)
      end

      alu.execute([9_i64])
      alu.x.should eq(-9)
      alu.y.should eq(0)
      alu.w.should eq(0)
      alu.z.should eq(0)
    end

    it "it should load the program correctly and test the output" do
      sample_instructions = ["inp z",
                             "inp x",
                             "mul z 3",
                             "eql z x"]
      alu = Day24::ALU.new
      sample_instructions.each do |line|
        alu.load_instruction(line)
      end

      alu.execute([3_i64, 9_i64])
      alu.x.should eq(9)
      alu.y.should eq(0)
      alu.w.should eq(0)
      alu.z.should eq(1)
    end

    it "it should load the program and test the output vars" do
      sample_instructions = ["inp w",
                             "add z w",
                             "mod z 2",
                             "div w 2",
                             "add y w",
                             "mod y 2",
                             "div w 2",
                             "add x w",
                             "mod x 2",
                             "div w 2",
                             "mod w 2"]
      alu = Day24::ALU.new
      sample_instructions.each do |line|
        alu.load_instruction(line)
      end

      alu.execute([15_i64])
      alu.x.should eq(1)
      alu.y.should eq(1)
      alu.w.should eq(1)
      alu.z.should eq(1)
    end
  end
end
