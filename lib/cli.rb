# frozen_string_literal: true

require_relative 'constants'
require_relative 'messages'
require_relative 'player'

class CLI
  def setup
    welcome
    @language = select_language
  end

  # @return [Symbol] e.g. :en, :fr
  def select_language
    language = nil

    until LANGUAGES.key?(language)
      puts LANGUAGES[:en][:select_language]
      language = gets.chomp.downcase.to_sym
    end

    language
  end

  def select_difficulty
    difficulty = nil

    until DIFFICULTY_LEVELS.key?(difficulty)
      puts LANGUAGES[@language][:select_difficulty]
      difficulty = gets.chomp.downcase.to_sym
    end

    difficulty
  end

  def create_player
    puts LANGUAGES[@language][:ask_name]
    name = gets.chomp
    Player.new(name, @language)
  end

  private

  def welcome
    puts LANGUAGES[:en][:welcome]
  end
end
