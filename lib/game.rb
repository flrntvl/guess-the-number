# frozen_string_literal: true

class Game
  DIFFICULTIES = {
    easy: { range: (1..50), max_attempts: 20 },
    medium: { range: (1..100), max_attempts: 15 },
    hard: { range: (1..500), max_attempts: 10 }
  }.freeze

  def start
    difficulty = ask_difficulty
    @range = DIFFICULTIES[difficulty][:range]
    @max_attempts = DIFFICULTIES[difficulty][:max_attempts]

    number = generate_number
    attempts = 0

    display_welcome

    loop do
      guess = ask_guess
      attempts += 1

      if correct?(guess, number)
        display_win(attempts)
        break
      elsif attempts >= @max_attempts
        display_loss(number)
        break
      else
        display_hint(guess, number)
        display_remaining_attempts(attempts)
      end
    end
  end

  private

  def ask_difficulty
    loop do
      display_difficulty_menu
      print '> '
      difficulty = resolve_difficulty(gets.chomp.strip.downcase)
      return difficulty if difficulty

      puts 'Please enter a valid choice.'
    end
  end

  def display_difficulty_menu
    puts 'Choose a difficulty level (enter its number or its name):'
    DIFFICULTIES.each_with_index do |(name, settings), index|
      puts "  #{index + 1}. #{name.capitalize} (1-#{settings[:range].last}, #{settings[:max_attempts]} attempts)"
    end
  end

  def resolve_difficulty(input)
    if input.match?(/\A\d+\z/)
      index = input.to_i - 1
      return DIFFICULTIES.keys[index] if index >= 0
    end

    input.to_sym if DIFFICULTIES.key?(input.to_sym)
  end

  def generate_number
    rand(@range)
  end

  def display_welcome
    puts "Guess the number between #{@range.first} and #{@range.last}!"
  end

  def ask_guess
    loop do
      print "Your guess (#{@range.first}-#{@range.last}): "
      input = gets.chomp

      next puts 'Please enter a valid number.' unless input.match?(/\A-?\d+\z/)

      guess = input.to_i
      return guess if @range.include?(guess)

      puts "Please enter a number between #{@range.first} and #{@range.last}."
    end
  end

  def correct?(guess, number)
    guess == number
  end

  def display_hint(guess, number)
    puts guess < number ? 'Too low!' : 'Too high!'
  end

  def display_remaining_attempts(attempts)
    puts "Attempts remaining: #{@max_attempts - attempts}"
  end

  def display_win(attempts)
    puts "You found it in #{attempts} attempts!"
  end

  def display_loss(number)
    puts "Game over! The number was #{number}."
  end
end
