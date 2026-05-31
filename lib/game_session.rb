# frozen_string_literal: true

require_relative 'constants'
require_relative 'messages'
require_relative 'player'

# Coordinates the flow of a game session: language, player setup, and game orchestration.
class GameSession
  # @return [Array(Symbol, Player)] difficulty and player, ready to init Game
  def run
    welcome
    @language = select_language
    difficulty = select_difficulty
    player = create_player
    [difficulty, player]
  end

  private

  # @return [Symbol] e.g. :en, :fr
  def select_language
    language = nil

    until LANGUAGES.key?(language)
      puts LANGUAGES[:en][:select_language]
      language = gets.chomp.downcase.to_sym
    end

    language
  end

  # @return [Symbol] e.g. :easy, :medium, :hard
  def select_difficulty
    difficulty = nil

    until DIFFICULTY_LEVELS.key?(difficulty)
      puts LANGUAGES[@language][:select_difficulty]
      difficulty = gets.chomp.downcase.to_sym
    end

    difficulty
  end

  # @return [Player] instance of Player with the entered name and @language
  def create_player
    puts LANGUAGES[@language][:ask_name]
    name = gets.chomp
    Player.new(name, @language)
  end

  def welcome
    puts LANGUAGES[:en][:welcome]
  end
end
