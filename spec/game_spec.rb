# frozen_string_literal: true

require 'game'

RSpec.describe Game do
  subject(:game) { described_class.new }

  def play(number:, guesses:, difficulty: 'medium')
    allow(game).to receive(:rand).and_return(number)
    inputs = [difficulty, *guesses].map { |value| "#{value}\n" }
    allow(game).to receive(:gets).and_return(*inputs)
  end

  describe '#start' do
    context 'guessing the number' do
      it 'declares victory when the guess is correct' do
        play(number: 42, guesses: [42])

        expect { game.start }.to output(/You found it in 1 attempts!/).to_stdout
      end

      it 'gives a "too low" hint when the guess is below the number' do
        play(number: 42, guesses: [10, 42])

        expect { game.start }.to output(/Too low!/).to_stdout
      end

      it 'gives a "too high" hint when the guess is above the number' do
        play(number: 42, guesses: [80, 42])

        expect { game.start }.to output(/Too high!/).to_stdout
      end

      it 'shows the remaining attempts after a wrong guess' do
        remaining = Game::DIFFICULTIES[:medium][:max_attempts] - 1
        play(number: 42, guesses: [10, 42])

        expect { game.start }.to output(/Attempts remaining: #{remaining}/).to_stdout
      end

      it 'declares defeat after exhausting all attempts' do
        max_attempts = Game::DIFFICULTIES[:medium][:max_attempts]
        play(number: 42, guesses: Array.new(max_attempts, 10))

        expect { game.start }.to output(/Game over! The number was 42\./).to_stdout
      end
    end

    context 'with invalid guess input' do
      it 're-prompts on non-numeric input' do
        play(number: 42, guesses: ['abc', 42])

        expect { game.start }.to output(/Please enter a valid number\./).to_stdout
      end

      it 're-prompts on out-of-range input' do
        play(number: 42, guesses: [101, 42])

        expect { game.start }.to output(/Please enter a number between 1 and 100\./).to_stdout
      end
    end

    context 'with difficulty selection' do
      it 'displays the difficulty menu' do
        play(number: 42, guesses: [42])

        expect { game.start }.to output(/Choose a difficulty level \(enter its number or its name\):/).to_stdout
      end

      it 'accepts a difficulty chosen by name' do
        play(number: 25, guesses: [25], difficulty: 'easy')

        expect { game.start }.to output(/Guess the number between 1 and 50!/).to_stdout
      end

      it 'accepts a difficulty chosen by menu number' do
        play(number: 25, guesses: [25], difficulty: '1')

        expect { game.start }.to output(/Guess the number between 1 and 50!/).to_stdout
      end

      it 'accepts medium as the selected difficulty' do
        play(number: 42, guesses: [42], difficulty: 'medium')

        expect { game.start }.to output(/Guess the number between 1 and 100!/).to_stdout
      end

      it 'applies the easy difficulty settings' do
        max_attempts = Game::DIFFICULTIES[:easy][:max_attempts]
        play(number: 25, guesses: Array.new(max_attempts, 10), difficulty: 'easy')

        expect { game.start }.to output(/Game over! The number was 25\./).to_stdout
      end

      it 'applies the selected difficulty settings' do
        max_attempts = Game::DIFFICULTIES[:hard][:max_attempts]
        play(number: 250, guesses: Array.new(max_attempts, 10), difficulty: 'hard')

        expect { game.start }.to output(/Game over! The number was 250\./).to_stdout
      end

      it 're-prompts on an invalid difficulty choice' do
        allow(game).to receive(:rand).and_return(42)
        allow(game).to receive(:gets).and_return("nonsense\n", "medium\n", "42\n")

        expect { game.start }.to output(/Please enter a valid choice\./).to_stdout
      end

      it 're-prompts on an out-of-range menu number, including zero' do
        allow(game).to receive(:rand).and_return(42)
        allow(game).to receive(:gets).and_return("0\n", "99\n", "medium\n", "42\n")

        expect { game.start }.to output(/Please enter a valid choice\./).to_stdout
      end
    end
  end
end
