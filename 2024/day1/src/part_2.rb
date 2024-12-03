# frozen_string_literal: true

require_relative "common"

arr1 = []
arr2 = []
while (line = $stdin.gets)
  v1, v2 = line.strip.split(/\s+/)
  arr1 << v1.to_i
  arr2 << v2.to_i
end

p Common.similarity(arr1, arr2)
