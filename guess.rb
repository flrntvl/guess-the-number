# frozen_string_literal: true

DIFFICULTY_LEVELS = {
  easy: { attempts: 15, range: 1..50 },
  medium: { attempts: 10, range: 1..100 },
  hard: { attempts: 5, range: 1..200 }
}.freeze

puts 'Welcome to the Number Guessing Game!'

difficulty = nil

until DIFFICULTY_LEVELS.key?(difficulty)
  puts 'Select a difficulty level: (easy, medium, hard)'
  difficulty = gets.chomp.downcase.to_sym
end

max_attempts = DIFFICULTY_LEVELS[difficulty][:attempts]
range = DIFFICULTY_LEVELS[difficulty][:range]

number_to_guess = rand(range)

puts "I'm thinking of a number between #{range.first} and #{range.last}. Can you guess it?"

attempts = 0

guess = nil

while guess != number_to_guess && attempts < max_attempts
  guess = gets.chomp.to_i

  attempts += 1

  if attempts < max_attempts
    if guess < number_to_guess
      puts 'Too low! Try again.'
    elsif guess > number_to_guess
      puts 'Too high! Try again.'
    end
  end

end

if guess == number_to_guess
  puts "Congratulations! You've guessed the number in #{attempts} attempts!"
else
  puts "Sorry, you've used all #{max_attempts} attempts. The number was #{number_to_guess}."
end
