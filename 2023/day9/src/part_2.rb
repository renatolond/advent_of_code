# frozen_string_literal: true

require_relative "common"

total = []
while (line = $stdin.gets)
  els = line.strip.split(/\s+/).map(&:to_i)
  sequences = [els]
  until els.all?(&:zero?)
    els = Common.derive(els)
    sequences << els
  end
  total << Common.rpredict(sequences)
end
p total.sum
