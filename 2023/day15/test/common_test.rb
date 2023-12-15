# frozen_string_literal: true

require_relative "../src/common"

require "minitest/autorun"

describe "common test" do
  describe "HASH" do
    it "hashes HASH" do
      assert_equal 52, Common.holiday_ascii_string_helper("HASH")
    end
    it "hashes the first part of init sequence" do
      assert_equal 30, Common.holiday_ascii_string_helper("rn=1")
    end
  end
end
