# frozen_string_literal: true

require_relative 'console_input'

# Plays one guessing round: prompts for guesses within a range until the
# secret number is found or the allowed attempts are exhausted.
class Round
  include ConsoleInput

  # Outcome of a finished round. A Struct avoids a full class for two
  # read-only data fields with equality and keyword initialization built in.
  Result = Struct.new(:attempts, :success, keyword_init: true)

  def initialize(range:, max_attempts:, number:, i18n:)
    @range = range
    @max_attempts = max_attempts
    @number = number
    @i18n = i18n
  end

  # Runs the guessing loop and returns a Result describing the outcome.
  def play
    display_welcome

    attempts = 0
    loop do
      guess = ask_guess
      attempts += 1

      if correct?(guess)
        display_win(attempts)
        return Result.new(attempts: attempts, success: true)
      elsif attempts >= @max_attempts
        display_loss
        return Result.new(attempts: attempts, success: false)
      else
        display_hint(guess)
        display_remaining_attempts(attempts)
      end
    end
  end

  private

  def t(key, **params)
    @i18n.t(key, **params)
  end

  # Asks for a valid numeric guess within the range, re-prompting otherwise.
  def ask_guess
    loop do
      print t(:guess_prompt, min: @range.first, max: @range.last)
      input = read_input

      next puts(t(:invalid_number)) unless input.match?(/\A-?\d+\z/)

      guess = input.to_i
      return guess if @range.include?(guess)

      puts t(:out_of_range, min: @range.first, max: @range.last)
    end
  end

  def correct?(guess)
    guess == @number
  end

  def display_welcome
    puts t(:welcome, min: @range.first, max: @range.last)
  end

  def display_hint(guess)
    puts guess < @number ? t(:too_low) : t(:too_high)
  end

  def display_remaining_attempts(attempts)
    puts t(:remaining_attempts, count: @max_attempts - attempts)
  end

  def display_win(attempts)
    puts t(:win, attempts: attempts)
  end

  def display_loss
    puts t(:loss, number: @number)
  end
end
