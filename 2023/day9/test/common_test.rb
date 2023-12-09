# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "derive" do
    it "derives for the first sample" do
      els = [0, 3, 6, 9, 12, 15]
      derived = [3, 3, 3, 3, 3]

      assert_equal derived, Common.derive(els)
    end
  end
  describe "predict" do
    it "predicts the next number for the first sequence" do
      sequences = [
        [0, 3, 6, 9, 12, 15],
        [3, 3, 3, 3, 3],
        [0, 0, 0, 0]
      ]

      assert_equal 18, Common.predict(sequences)
    end
    it "predicts the next number for the second sequence" do
      sequences = [
        [1, 3, 6, 10, 15, 21],
        [2, 3, 4, 5, 6],
        [1, 1, 1, 1],
        [0, 0, 0]
      ]

      assert_equal 28, Common.predict(sequences)
    end
  end
  describe "rpredict" do
    it "predicts the previous number for the first sequence" do
      sequences = [
        [0, 3, 6, 9, 12, 15],
        [3, 3, 3, 3, 3],
        [0, 0, 0, 0]
      ]

      assert_equal(-3, Common.rpredict(sequences))
    end
    it "predicts the previous number for the second sequence" do
      sequences = [
        [1, 3, 6, 10, 15, 21],
        [2, 3, 4, 5, 6],
        [1, 1, 1, 1],
        [0, 0, 0]
      ]

      assert_equal 0, Common.rpredict(sequences)
    end
    it "predicts the previous number for the last sequence XXXXX" do
      sequences = [
        [10, 13, 16, 21, 30, 45, 68],
        [3, 3, 5, 9, 15, 23],
        [0, 2, 4, 6, 8],
        [2, 2, 2, 2],
        [0, 0, 0]
      ]

      assert_equal 5, Common.rpredict(sequences)
    end
  end
end
