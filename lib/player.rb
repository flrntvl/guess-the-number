# frozen_string_literal: true

class Player
  attr_reader :name, :language

  # @param name [String] name entered by the player
  # @param language [Symbol] e.g. :en, :fr
  def initialize(name, language)
    @name = name
    @language = language
  end
end
