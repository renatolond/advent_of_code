# frozen_string_literal: true

module Common
  class << self
    # @return [Array<List(Integer, Integer)>]
    def paired_values(arr1, arr2)
      arr1.sort
          .zip(arr2.sort)
    end

    def distance_of_paired_values(arr1, arr2)
      pairs = paired_values(arr1, arr2)
      pairs.sum do |v1, v2|
        if v1 > v2
          v1 - v2
        else
          v2 - v1
        end
      end
    end

    def similarity(arr1, arr2)
      total = arr2.sort.tally
      arr1.sum do |v|
        (total[v] || 0) * v
      end
    end
  end
end
