require "./spec_helper"

describe Day12 do
  # TODO: Write tests

  it "with sample input 1, there should be 10 paths" do
    sample_input = %w[start-A
start-b
A-c
A-b
b-d
A-end
b-end]
    possible_paths = %w[start,A,b,A,c,A,end
start,A,b,A,end
start,A,b,end
start,A,c,A,b,A,end
start,A,c,A,b,end
start,A,c,A,end
start,A,end
start,b,A,c,A,end
start,b,A,end
start,b,end]
    cg = Day12::CaveGraph.new
    sample_input.each do |line|
      cg.add_link(line)
    end
    cg.find_paths
    cg.paths.should eq(possible_paths)
    cg.num_paths.should eq(10)
  end
  it "with sample input 2, there should be 19 paths" do
    sample_input = %w[dc-end
HN-start
start-kj
dc-start
dc-HN
LN-dc
HN-end
kj-sa
kj-HN
kj-dc]
    possible_paths = %w[start,HN,dc,HN,end
start,HN,dc,HN,kj,HN,end
start,HN,dc,end
start,HN,dc,kj,HN,end
start,HN,end
start,HN,kj,HN,dc,HN,end
start,HN,kj,HN,dc,end
start,HN,kj,HN,end
start,HN,kj,dc,HN,end
start,HN,kj,dc,end
start,dc,HN,end
start,dc,HN,kj,HN,end
start,dc,end
start,dc,kj,HN,end
start,kj,HN,dc,HN,end
start,kj,HN,dc,end
start,kj,HN,end
start,kj,dc,HN,end
start,kj,dc,end]
    cg = Day12::CaveGraph.new
    sample_input.each do |line|
      cg.add_link(line)
    end
    cg.find_paths
    cg.paths.should eq(possible_paths)
    cg.num_paths.should eq(19)
  end
  it "with sample input 3, there should be 226 paths or 3509 if revisiting" do
    sample_input = %w[fs-end
he-DX
fs-he
start-DX
pj-DX
end-zg
zg-sl
zg-pj
pj-he
RW-he
fs-DX
pj-RW
zg-RW
start-pj
he-WI
zg-he
pj-fs
start-RW]
    cg = Day12::CaveGraph.new
    sample_input.each do |line|
      cg.add_link(line)
    end
    cg.find_paths
    cg.num_paths.should eq(226)
    cg = Day12::CaveGraph.new(true)
    sample_input.each do |line|
      cg.add_link(line)
    end
    cg.find_paths
    cg.num_paths.should eq(3509)
  end

  it "avoids infinite loops" do
    sample_input = %w[start-A
A-B
B-end
A-end]
    cg = Day12::CaveGraph.new
    sample_input.each do |line|
      cg.add_link(line)
    end
    cg.find_paths
  end
  it "with sample input 1, revisiting caves, there should be 36 paths" do
    sample_input = %w[start-A
start-b
A-c
A-b
b-d
A-end
b-end]
    possible_paths = %w[start,A,b,A,b,A,c,A,end
start,A,b,A,b,A,end
start,A,b,A,b,end
start,A,b,A,c,A,b,A,end
start,A,b,A,c,A,b,end
start,A,b,A,c,A,c,A,end
start,A,b,A,c,A,end
start,A,b,A,end
start,A,b,d,b,A,c,A,end
start,A,b,d,b,A,end
start,A,b,d,b,end
start,A,b,end
start,A,c,A,b,A,b,A,end
start,A,c,A,b,A,b,end
start,A,c,A,b,A,c,A,end
start,A,c,A,b,A,end
start,A,c,A,b,d,b,A,end
start,A,c,A,b,d,b,end
start,A,c,A,b,end
start,A,c,A,c,A,b,A,end
start,A,c,A,c,A,b,end
start,A,c,A,c,A,end
start,A,c,A,end
start,A,end
start,b,A,b,A,c,A,end
start,b,A,b,A,end
start,b,A,b,end
start,b,A,c,A,b,A,end
start,b,A,c,A,b,end
start,b,A,c,A,c,A,end
start,b,A,c,A,end
start,b,A,end
start,b,d,b,A,c,A,end
start,b,d,b,A,end
start,b,d,b,end
start,b,end]
    cg = Day12::CaveGraph.new(true)
    sample_input.each do |line|
      cg.add_link(line)
    end
    cg.find_paths
    cg.paths.should eq(possible_paths)
    cg.num_paths.should eq(36)
  end
end
