# frozen_string_literal: true

# Represents a player identified by their name.
class Player
  attr_reader :name

  def initialize(name)
    @name = name
  end
end
