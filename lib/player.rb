# frozen_string_literal: true

require_relative 'console_input'
require_relative 'i18n'

# Represents a player and handles asking for their name: re-prompts until a
# non-empty name is entered.
class Player
  include ConsoleInput

  attr_reader :name

  def initialize(name)
    @name = name
  end

  # Prompts for a player name and loops until it is not empty.
  def self.ask(i18n:)
    loop do
      print i18n.t(:name_prompt)
      name = ConsoleInput.read_input
      return new(name) unless name.empty?

      puts i18n.t(:empty_name)
    end
  end
end
