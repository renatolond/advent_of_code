require "./spec_helper"

describe Day21 do
  # TODO: Write tests
  it "with sample input, get expected results" do
    sample_input = ["Player 1 starting position: 4",
                    "Player 2 starting position: 8"]
    dice_game = Day21::DeterministicDiracDice.new
    sample_input.each do |line|
      dice_game.setup_player(line)
    end
    dice_game.play!
    dice_game.formula.should eq(739785)
  end
  it "with sample input, get expected results" do
    sample_input = ["Player 1 starting position: 4",
                    "Player 2 starting position: 8"]
    dice_game = Day21::DiracDice.new
    sample_input.each do |line|
      dice_game.setup_player(line)
    end
    dice_game.play!
    dice_game.wins.should eq([444356092776315, 341960390180808])
  end
end
