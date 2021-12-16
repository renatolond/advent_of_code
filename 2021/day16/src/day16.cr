# TODO: Write documentation for `Day9`
module Day16
  VERSION = "0.1.0"

  class Packet
    def type
      raise "Not implemented"
    end
    def version
      raise "Not implemented"
    end
    def number
      raise "Not implemented"
    end
    def self.parse(str_representation) : Tuple(Int32, Packet)
      raise "Not implemented"
    end

    def sum_of_version_numbers
      raise "Not implemented"
    end
    def operate(args) : Int64
      raise "Not implemented"
    end
    def value
      raise "Not implemented"
    end
  end

  class OperatorPacket < Packet
    @subpackets : Array(Packet)
    @version : Int64
    @operator_type : Symbol

    getter version
    getter subpackets

    def operate(args) : Int64
      raise "Not implemented"
    end
    def initialize(version, subpackets, operator_type)
      super()
      @version = version
      @subpackets = subpackets
      @operator_type = operator_type
    end

    def self.parse(str_representation) : Tuple(Int32, Packet)
      subpackets = [] of Packet
      version = str_representation[0..2].to_i64(2)
      operator_type_str = str_representation[6]
      packet_size = 0
      if operator_type_str == '0'
        operator_type = :subpacket_length
        subpackets_idx = 7 + 15
        length = str_representation[7..subpackets_idx-1].to_i64(2)
        packet_size = subpackets_idx
        while length > 0
          subpacket_str = str_representation[subpackets_idx..]
          klass = PacketDecoder.packet_class(subpacket_str)
          size, sps= klass.parse(subpacket_str)
          subpackets_idx += size
          packet_size += size
          length -= size
          subpackets << sps
        end
      else
        operator_type = :subpacket_qty
        subpackets_idx = 7 + 11
        qty = str_representation[7..subpackets_idx-1].to_i64(2)
        packet_size = subpackets_idx
        while qty > 0
          qty -= 1
          subpacket_str = str_representation[subpackets_idx..]
          klass = PacketDecoder.packet_class(subpacket_str)
          size, sps = klass.parse(subpacket_str)
          subpackets << sps
          subpackets_idx += size
          packet_size += size
        end
      end
      return packet_size, self.new(version, subpackets, operator_type)
    end

    def type
      "operator"
    end

    def sum_of_version_numbers
      @version + @subpackets.sum { |p| p.sum_of_version_numbers }
    end

    def value : Int64
      operate(@subpackets)
    end
  end

  class LiteralPacket < Packet
    @version : Int64
    @number : Int64
    getter number
    getter version
    def initialize(version, number)
      super()
      @version = version
      @number = number
    end

    def type
      "literal"
    end

    def self.parse(str_representation) : Tuple(Int32, Packet)
      version = str_representation[0..2].to_i64(2)
      number = 0_i64
      idx = 6
      number_as_str = ""
      while true
        continue_bit = str_representation[idx]
        number_as_str = number_as_str + str_representation[idx+1..idx+4]
        idx += 5
        break unless continue_bit == '1'
      end
      return idx, LiteralPacket.new(version, number_as_str.to_i64(2))
    end

    def sum_of_version_numbers
      @version
    end
    def value : Int64
      @number
    end
  end

  class SumPacket < OperatorPacket
    def operate(args) : Int64
      args.map(&.value).sum
    end
  end

  class ProductPacket < OperatorPacket
    def operate(args) : Int64
      args.map(&.value).product(1_i64)
    end
  end

  class MinimumPacket < OperatorPacket
    def operate(args) : Int64
      args.map(&.value).min
    end
  end

  class MaximumPacket < OperatorPacket
    def operate(args) : Int64
      args.map(&.value).max
    end
  end

  class GreaterThanPacket < OperatorPacket
    def operate(args) : Int64
      if args[0].value > args[1].value
        1_i64
      else
        0_i64
      end
    end
  end

  class LessThanPacket < OperatorPacket
    def operate(args) : Int64
      if args[0].value < args[1].value
        1_i64
      else
        0_i64
      end
    end
  end

  class EqualToPacket < OperatorPacket
    def operate(args) : Int64
      if args[0].value == args[1].value
        1_i64
      else
        0_i64
      end
    end
  end

  class PacketDecoder
    @packets = [] of Packet

    def self.packet_class(str)
      case str[3..5]
      when "000"
        SumPacket
      when "001"
        ProductPacket
      when "010"
        MinimumPacket
      when "011"
        MaximumPacket
      when "100"
        LiteralPacket
      when "101"
        GreaterThanPacket
      when "110"
        LessThanPacket
      when "111"
        EqualToPacket
      else
        OperatorPacket
      end
    end

    def read(line)
      str = ""
      line.chars.each do |chr|
        int_representation = chr.to_s.to_i64(16)
        local_str = ""
        4.times do |i|
          digit = (int_representation & 1)
          int_representation = int_representation >> 1
          local_str = digit.to_s + local_str
        end

        str += local_str
      end
      while str.size % 8 != 0
        str = "0" + str
      end
      klass = PacketDecoder.packet_class(str)
      size, packet = klass.parse(str)
      @packets << packet
    end

    def first_packet
      @packets[0]
    end

    def packet_type
      @packets[0].type
    end

    def sum_of_version_numbers
      @packets[0].sum_of_version_numbers
    end

    def value
      @packets[0].value
    end
  end

  def self.part_1()
    packet_dec = Day16::PacketDecoder.new
    if (line = gets())
      packet_dec.read(line)
    end

    puts packet_dec.sum_of_version_numbers
  end

  def self.part_2()
    packet_dec = Day16::PacketDecoder.new
    if (line = gets())
      packet_dec.read(line)
    end

    puts packet_dec.value
  end
end
