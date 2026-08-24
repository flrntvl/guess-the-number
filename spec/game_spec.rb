# frozen_string_literal: true

require 'game'
require 'language_selector'
require 'scoreboard'

# End-to-end specs for the whole game flow. Focused behavior (hints, invalid
# input, menu resolution, name validation) is covered by the unit specs of
# Round, ConsoleMenu, Player and LanguageSelector; these examples only check
# that Game wires everything together.
RSpec.describe Game do
  # subject: the object under test, rebuilt before every `it`.
  # Doubles are injected so no real file, language prompt or random draw occurs.
  subject(:game) do
    described_class.new(
      language_selector: language_selector,
      scoreboard: scoreboard,
      random: random_generator
    )
  end

  # let + instance_double: a fake verifying the real class' interface.
  # `select` answers :en, `save` does nothing, `top` returns no scores.
  let(:language_selector) { instance_double(LanguageSelector, select: :en) }
  let(:scoreboard) { instance_double(Scoreboard, save: nil, top: []) }
  let(:random_generator) { instance_double(Random, rand: number_to_guess) }
  let(:number_to_guess) { 42 }

  # Helper scripting a full session: fixes the secret number, then queues
  # every answer in order (menu action, name, difficulty, guesses, quit).
  def play(number:, guesses:, difficulty: 'medium', language: :en, name: 'Alice', action: '1')
    allow(random_generator).to receive(:rand).and_return(number)
    # The trailing "quit" exits the main menu loop once gets stubs repeat their last value.
    inputs = [action, name, difficulty, *guesses, 'quit'].map { |value| "#{value}\n" }
    allow($stdin).to receive(:gets).and_return(*inputs)
    allow(language_selector).to receive(:select).and_return(language)
  end

  describe '#start' do
    # Runs the game while capturing standard output.
    def capture_stdout
      original = $stdout
      $stdout = StringIO.new
      yield
      $stdout.string
    ensure
      $stdout = original
    end

    context 'when playing a round' do
      it 'runs a full winning round' do
        play(number: 42, guesses: [10, 42])

        output = capture_stdout { game.start }

        expect(output).to include('Too low!', 'You found it in 2 attempts!')
      end

      it 'declares defeat after exhausting all attempts' do
        max_attempts = Game::DIFFICULTIES[:medium][:max_attempts]
        play(number: 42, guesses: Array.new(max_attempts, 10))

        expect { game.start }.to output(/Game over! The number was 42\./).to_stdout
      end
    end

    context 'when playing in French' do
      it 'runs a full winning round in French' do
        play(number: 42, guesses: [10, 42], language: :fr)

        output = capture_stdout { game.start }

        expect(output).to include('Trop petit !', 'Vous avez trouvé en 2 tentative(s) !')
      end

      it 'displays the difficulty menu in the selected language' do
        play(number: 42, guesses: [42], language: :fr)

        output = capture_stdout { game.start }

        expect(output).to include(
          'Choisissez un niveau de difficulté (son numéro ou son nom) :',
          '1. Facile', '2. Moyen', '3. Difficile'
        )
      end
    end

    context 'with main menu' do
      it 'shows the leaderboard when chosen by number' do
        allow($stdin).to receive(:gets).and_return("2\n", "3\n")

        expect { game.start }.to output(/No scores yet\./).to_stdout
        expect(scoreboard).to have_received(:top).at_least(3).times
      end

      it 'accepts an action chosen by name' do
        allow($stdin).to receive(:gets).and_return("leaderboard\n", "quit\n")

        expect { game.start }.to output(/Top scores/).to_stdout
      end
    end

    context 'when standard input ends (EOF)' do
      it 'exits gracefully at the main menu prompt' do
        allow($stdin).to receive(:gets).and_return(nil)

        expect { game.start }.to output(/Goodbye!/).to_stdout
      end

      it 'exits gracefully in the middle of a round' do
        allow(random_generator).to receive(:rand).and_return(42)
        allow($stdin).to receive(:gets).and_return("1\n", "Alice\n", nil)

        expect { game.start }.to output(/Goodbye!/).to_stdout
      end

      it 'exits gracefully before the language is chosen' do
        allow(language_selector).to receive(:select).and_raise(EndOfInput)

        expect { game.start }.to output(/Goodbye!/).to_stdout
      end
    end

    context 'with score saving' do
      # Freeze Time so the saved timestamp can be asserted exactly.
      before do
        allow(Time).to receive(:now).and_return(Time.new(2026, 5, 22, 10, 30, 0, '+02:00'))
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
      it 'applies the easy difficulty settings' do
        max_attempts = Game::DIFFICULTIES[:easy][:max_attempts]
        play(number: 25, guesses: Array.new(max_attempts, 10), difficulty: 'easy')

        expect { game.start }.to output(/Game over! The number was 25\./).to_stdout
      end

      it 'applies the hard difficulty settings' do
        max_attempts = Game::DIFFICULTIES[:hard][:max_attempts]
        play(number: 250, guesses: Array.new(max_attempts, 10), difficulty: 'hard')

        expect { game.start }.to output(/Game over! The number was 250\./).to_stdout
      end
    end
  end
end
