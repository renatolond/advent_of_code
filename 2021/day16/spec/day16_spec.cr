require "./spec_helper"

describe Day16 do
  # TODO: Write tests

  it "with sample input, packet should be literal value" do
    sample_input = ["D2FE28"]
    packet_dec = Day16::PacketDecoder.new
    sample_input.each do |line|
      packet_dec.read(line)
    end

    packet_dec.first_packet.type.should eq("literal")
    packet_dec.sum_of_version_numbers.should eq(6)
    packet_dec.value.should eq(2021)
  end

  it "with sample input, packet should be operator" do
    sample_input = ["38006F45291200"]
    packet_dec = Day16::PacketDecoder.new
    sample_input.each do |line|
      packet_dec.read(line)
    end

    packet_dec.first_packet.type.should eq("operator")
    packet_dec.first_packet.version.should eq(1)
    packet_dec.sum_of_version_numbers.should eq(9)
  end
  it "with sample input, packet should be operator" do
    sample_input = ["EE00D40C823060"]
    packet_dec = Day16::PacketDecoder.new
    sample_input.each do |line|
      packet_dec.read(line)
    end

    packet_dec.first_packet.type.should eq("operator")
    packet_dec.first_packet.version.should eq(7)
    packet_dec.sum_of_version_numbers.should eq(14)
  end

  it "with different sample inputs, check sum_of_versions" do
    packet_dec = Day16::PacketDecoder.new
    packet_dec.read("8A004A801A8002F478")
    packet_dec.sum_of_version_numbers.should eq(16)

    packet_dec = Day16::PacketDecoder.new
    packet_dec.read("620080001611562C8802118E34")
    packet_dec.sum_of_version_numbers.should eq(12)

    packet_dec = Day16::PacketDecoder.new
    packet_dec.read("C0015000016115A2E0802F182340")
    packet_dec.sum_of_version_numbers.should eq(23)

    packet_dec = Day16::PacketDecoder.new
    packet_dec.read("A0016C880162017C3686B18A3D4780")
    packet_dec.sum_of_version_numbers.should eq(31)
  end

  it "tests operators" do
    packet_dec = Day16::PacketDecoder.new
    packet_dec.read("C200B40A82")
    packet_dec.value.should eq(3)

    packet_dec = Day16::PacketDecoder.new
    packet_dec.read("04005AC33890")
    packet_dec.value.should eq(54)

    packet_dec = Day16::PacketDecoder.new
    packet_dec.read("880086C3E88112")
    packet_dec.value.should eq(7)

    packet_dec = Day16::PacketDecoder.new
    packet_dec.read("CE00C43D881120")
    packet_dec.value.should eq(9)

    packet_dec = Day16::PacketDecoder.new
    packet_dec.read("D8005AC2A8F0")
    packet_dec.value.should eq(1)

    packet_dec = Day16::PacketDecoder.new
    packet_dec.read("F600BC2D8F")
    packet_dec.value.should eq(0)

    packet_dec = Day16::PacketDecoder.new
    packet_dec.read("9C005AC2F8F0")
    packet_dec.value.should eq(0)

    packet_dec = Day16::PacketDecoder.new
    packet_dec.read("9C0141080250320F1802104A08")
    packet_dec.value.should eq(1)
  end
end
