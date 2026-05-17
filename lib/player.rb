# frozen_string_literal: true

class Player
  attr_reader :name, :language

  # @param language [Symbol] e.g. :en, :fr
  def initialize(name, language)
    @name = name
    @language = language
  end
end
