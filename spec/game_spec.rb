# frozen_string_literal: true

require 'game'

RSpec.describe Game do
  subject(:game) { described_class.new }

  def play(number:, guesses:)
    allow(game).to receive(:rand).and_return(number)
    allow(game).to receive(:gets).and_return(*guesses.map { |guess| "#{guess}\n" })
  end

  describe '#start' do
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
      play(number: 42, guesses: [10, 42])

      expect { game.start }.to output(/Attempts remaining: 9/).to_stdout
    end

    it 'declares defeat after exhausting all attempts' do
      play(number: 42, guesses: Array.new(Game::MAX_ATTEMPTS, 10))

      expect { game.start }.to output(/Game over! The number was 42\./).to_stdout
    end

    it 're-prompts on non-numeric input' do
      play(number: 42, guesses: ['abc', 42])

      expect { game.start }.to output(/Please enter a valid number\./).to_stdout
    end

    it 're-prompts on out-of-range input' do
      play(number: 42, guesses: [101, 42])

      expect { game.start }.to output(/Please enter a number between 1 and 100\./).to_stdout
    end
  end
end
