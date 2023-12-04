# frozen_string_literal: true

Handful = Data.define(:blue, :red, :green) do
  def initialize(blue: 0, red: 0, green: 0) = super
end
