# frozen_string_literal: true

module Common
  class << self
    def initialize_possible_designs
      # @type [Set]
      @possible_designs = {}
      @impossible_designs = Set.new
    end

    # @param design [String]
    # @param towel_types [Hash{String => Array<String>}]
    # @return [Boolean]
    def design_possible?(design, towel_types)
      return false unless towel_types.key?(design[0])
      return false if @impossible_designs.include?(design)
      return true if @possible_designs.key?(design)

      towel_types[design[0]].each do |towel_type|
        next unless design.start_with?(towel_type)

        if design == towel_type
          @possible_designs[design] = true
          return true
        end

        possible = design_possible?(design[towel_type.size..], towel_types)
        if possible
          @possible_designs[design] = true
          return true
        end
      end
      @impossible_designs << design
      false
    end

    # @param design [String]
    # @param towel_types [Hash{String => Array<String>}]
    # @return [Integer]
    def design_count(design, towel_types)
      return 0 unless towel_types.key?(design[0])
      return 0 if @impossible_designs.include?(design)
      return @possible_designs[design] if @possible_designs.key?(design)

      possible = 0
      towel_types[design[0]].each do |towel_type|
        next unless design.start_with?(towel_type)

        if design == towel_type
          @possible_designs[design] ||= 0
          @possible_designs[design] += 1
          next
        end

        possible = design_count(design[towel_type.size..], towel_types)
        if possible
          @possible_designs[design] ||= 0
          @possible_designs[design] += possible
        end
      end
      return @possible_designs[design] if @possible_designs.key?(design)

      @impossible_designs << design
      0
    end
  end
end
