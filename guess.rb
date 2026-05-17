# frozen_string_literal: true

require 'json'
require_relative 'messages'

DIFFICULTY_LEVELS = {
  easy: { attempts: 15, range: 1..50 },
  medium: { attempts: 10, range: 1..100 },
  hard: { attempts: 5, range: 1..200 }
}.freeze

puts LANGUAGES[:en][:welcome]

language = nil

until LANGUAGES.key?(language)
  puts LANGUAGES[:en][:select_language]
  language = gets.chomp.downcase.to_sym
end

puts LANGUAGES[language][:ask_name]

player_name = gets.chomp

difficulty = nil

until DIFFICULTY_LEVELS.key?(difficulty)
  puts LANGUAGES[language][:select_difficulty]
  difficulty = gets.chomp.downcase.to_sym
end

max_attempts = DIFFICULTY_LEVELS[difficulty][:attempts]
range = DIFFICULTY_LEVELS[difficulty][:range]

number_to_guess = rand(range)

puts format(LANGUAGES[language][:thinking], range.first, range.last)

attempts = 0

guess = nil

while guess != number_to_guess && attempts < max_attempts
  guess = gets.chomp.to_i

  attempts += 1

  if attempts < max_attempts
    if guess < number_to_guess
      puts LANGUAGES[language][:too_low]
    elsif guess > number_to_guess
      puts LANGUAGES[language][:too_high]
    end
  end

end

if guess == number_to_guess
  puts format(LANGUAGES[language][:win], attempts)
else
  puts format(LANGUAGES[language][:lose], max_attempts, number_to_guess)
end

game_result = {
  player_name: player_name,
  difficulty: difficulty,
  attempts: attempts,
  number_to_guess: number_to_guess,
  success: guess == number_to_guess,
  timestamp: Time.now
}.freeze

results_file = begin
  JSON.parse(File.read('results.json'))
rescue StandardError
  []
end
results_file << game_result

File.write('results.json', JSON.pretty_generate(results_file))
