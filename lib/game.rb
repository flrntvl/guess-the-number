# frozen_string_literal: true

class Game
  MAX_ATTEMPTS = 10
  RANGE = (1..100).freeze

  def start
    number = generate_number
    attempts = 0

    display_welcome

    loop do
      guess = ask_guess
      attempts += 1

      if correct?(guess, number)
        display_win(attempts)
        break
      elsif attempts >= MAX_ATTEMPTS
        display_loss(number)
        break
      else
        display_hint(guess, number)
        display_remaining_attempts(attempts)
      end
    end
  end

  private

  def generate_number
    rand(RANGE)
  end

  def display_welcome
    puts "Guess the number between #{RANGE.first} and #{RANGE.last}!"
  end

  def ask_guess
    loop do
      print "Your guess (#{RANGE.first}-#{RANGE.last}): "
      input = gets.chomp

      next puts 'Please enter a valid number.' unless input.match?(/\A-?\d+\z/)

      guess = input.to_i
      return guess if RANGE.include?(guess)

      puts "Please enter a number between #{RANGE.first} and #{RANGE.last}."
    end
  end

  def correct?(guess, number)
    guess == number
  end

  def display_hint(guess, number)
    puts guess < number ? 'Too low!' : 'Too high!'
  end

  def display_remaining_attempts(attempts)
    puts "Attempts remaining: #{MAX_ATTEMPTS - attempts}"
  end

  def display_win(attempts)
    puts "You found it in #{attempts} attempts!"
  end

  def display_loss(number)
    puts "Game over! The number was #{number}."
  end
end
