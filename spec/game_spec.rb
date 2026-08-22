# frozen_string_literal: true

require 'game'
require 'language_selector'
require 'scoreboard'

RSpec.describe Game do
  let(:language_selector) { instance_double(LanguageSelector, select: :en) }
  let(:scoreboard) { instance_double(Scoreboard, save: nil) }

  subject(:game) { described_class.new(language_selector: language_selector, scoreboard: scoreboard) }

  def play(number:, guesses:, difficulty: 'medium', language: :en, name: 'Alice')
    allow(game).to receive(:rand).and_return(number)
    inputs = [name, difficulty, *guesses].map { |value| "#{value}\n" }
    allow(game).to receive(:gets).and_return(*inputs)
    allow(language_selector).to receive(:select).and_return(language)
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

    context 'in French' do
      it 'gives a "too low" hint when the guess is below the number' do
        play(number: 42, guesses: [10, 42], language: :fr)

        expect { game.start }.to output(/Trop petit !/).to_stdout
      end

      it 'gives a "too high" hint when the guess is above the number' do
        play(number: 42, guesses: [80, 42], language: :fr)

        expect { game.start }.to output(/Trop grand !/).to_stdout
      end

      it 'declares victory in French when the guess is correct' do
        play(number: 42, guesses: [42], language: :fr)

        expect { game.start }.to output(/Vous avez trouvé en 1 tentative\(s\) !/).to_stdout
      end

      it 'declares defeat in French after exhausting all attempts' do
        max_attempts = Game::DIFFICULTIES[:medium][:max_attempts]
        play(number: 42, guesses: Array.new(max_attempts, 10), language: :fr)

        expect { game.start }.to output(/Perdu ! Le nombre était 42\./).to_stdout
      end
    end

    context 'with score saving' do
      before do
        allow(Time).to receive(:now).and_return(Time.new(2026, 5, 22, 10, 30, 0, '+02:00'))
      end

      it 'greets the player by name' do
        play(number: 42, guesses: [42], name: 'Bob')

        expect { game.start }.to output(/Hello Bob!/).to_stdout
      end

      it 're-prompts on an empty name until a valid one is given' do
        allow(game).to receive(:rand).and_return(42)
        allow(game).to receive(:gets).and_return("\n", "   \n", "Alice\n", "medium\n", "42\n")

        expect { game.start }.to output(/Please enter a name\./).to_stdout
      end

      it 'saves the result when the player wins' do
        play(number: 42, guesses: [42])

        expect { game.start }.to output.to_stdout

        expect(scoreboard).to have_received(:save).with(
          player_name: 'Alice',
          difficulty: 'medium',
          attempts: 1,
          language: 'en',
          number_to_guess: 42,
          success: true,
          timestamp: '2026-05-22 10:30:00 +0200'
        )
      end

      it 'saves the result when the player loses' do
        max_attempts = Game::DIFFICULTIES[:medium][:max_attempts]
        play(number: 42, guesses: Array.new(max_attempts, 10))

        expect { game.start }.to output.to_stdout

        expect(scoreboard).to have_received(:save).with(
          hash_including(success: false, attempts: max_attempts)
        )
      end

      it 'saves the selected language in the result' do
        play(number: 42, guesses: [42], language: :fr)

        expect { game.start }.to output.to_stdout

        expect(scoreboard).to have_received(:save).with(hash_including(language: 'fr'))
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
        allow(game).to receive(:gets).and_return("Alice\n", "nonsense\n", "medium\n", "42\n")

        expect { game.start }.to output(/Please enter a valid choice\./).to_stdout
      end

      it 're-prompts on an out-of-range menu number, including zero' do
        allow(game).to receive(:rand).and_return(42)
        allow(game).to receive(:gets).and_return("Alice\n", "0\n", "99\n", "medium\n", "42\n")

        expect { game.start }.to output(/Please enter a valid choice\./).to_stdout
      end
    end
  end
end
