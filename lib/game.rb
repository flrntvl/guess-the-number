# frozen_string_literal: true

require_relative 'difficulty'
require_relative 'translations'

class Game
  # @param difficulty [Symbol] e.g. :easy, :medium, :hard
  # @param player [Player] instance of Player, provides name and language
  def initialize(difficulty, player)
    @difficulty = difficulty
    @guess = nil
    @attempts = 0
    @max_attempts = DIFFICULTY_LEVELS[difficulty][:attempts]
    @range = DIFFICULTY_LEVELS[difficulty][:range]
    @number_to_guess = generate_number
    @player_name = player.name
    @language = player.language
  end

  def play
    announce_range

    while @guess != @number_to_guess && @attempts < @max_attempts
      @guess = ask_guess
      @attempts += 1
      display_feedback
    end

    display_result
  end

  # @return [Hash] game result, ready to be saved by ScoreBoard
  def to_result
    {
      player_name: @player_name,
      difficulty: @difficulty,
      attempts: @attempts,
      language: @language,
      number_to_guess: @number_to_guess,
      success: @guess == @number_to_guess,
      timestamp: Time.now
    }
  end

  private

  def generate_number
    rand(@range)
  end

  def announce_range
    puts format(LANGUAGES[@language][:thinking], @range.first, @range.last)
  end

  def ask_guess
    loop do
      print LANGUAGES[@language][:ask_guess]
      input = gets.chomp
      return input.to_i if input.match?(/\A-?\d+\z/)

      puts LANGUAGES[@language][:invalid_guess]
    end
  end

  def display_feedback
    return unless @attempts < @max_attempts

    if @guess < @number_to_guess
      puts LANGUAGES[@language][:too_low]
    elsif @guess > @number_to_guess
      puts LANGUAGES[@language][:too_high]
    end
  end

  def display_result
    if @guess == @number_to_guess
      puts format(LANGUAGES[@language][:win], @attempts)
    else
      puts format(LANGUAGES[@language][:lose], @max_attempts, @number_to_guess)
    end
  end
end
