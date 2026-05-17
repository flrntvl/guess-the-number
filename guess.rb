# frozen_string_literal: true

MAX_ATTEMPTS = 10
number_to_guess = rand(1..100)

puts 'Welcome to the Number Guessing Game!'
puts "I'm thinking of a number between 1 and 100. Can you guess it?"

attempts = 0

guess = nil

while guess != number_to_guess && attempts < MAX_ATTEMPTS
  guess = gets.chomp.to_i

  attempts += 1

  if attempts < MAX_ATTEMPTS
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
  puts "Sorry, you've used all #{MAX_ATTEMPTS} attempts. The number was #{number_to_guess}."
end
