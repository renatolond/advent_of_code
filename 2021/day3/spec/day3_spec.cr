require "./spec_helper"

describe Day3 do
  # TODO: Write tests

  it "witht the sample input, gamma rate is 22 and epsilon is 9" do
    sample_input = %w[
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
    ]
    sub_diag = Day3::SubmarineDiagnostics.new(5_i64)
    sample_input.each do |line|
      sub_diag.read_report(line)
    end

    sub_diag.gamma_rate.should eq(22)
    sub_diag.epsilon_rate.should eq(9)
    sub_diag.oxygen_gen_rating.should eq(23)
    sub_diag.co2_scrubber_rating.should eq(10)
    sub_diag.power_consumption.should eq(198)
    sub_diag.life_support_rating.should eq(230)
  end
end
