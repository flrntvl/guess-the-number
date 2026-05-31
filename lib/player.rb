# frozen_string_literal: true

class Player
  attr_reader :name

  # @param name [String] name entered by the player
  def initialize(name)
    @name = name
  end
end
