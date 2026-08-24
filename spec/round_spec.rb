# frozen_string_literal: true

require 'round'
require 'i18n'

RSpec.describe Round do
  subject(:round) do
    described_class.new(
      range: range,
      max_attempts: max_attempts,
      number: number,
      i18n: I18n.new(:en)
    )
  end

  let(:range) { 1..100 }
  let(:max_attempts) { 3 }
  let(:number) { 42 }

  def feed(*values)
    allow($stdin).to receive(:gets).and_return(*values.map { |value| "#{value}\n" })
  end

  it 'returns a winning result on the correct guess' do
    feed(42)

    expect(round.play).to have_attributes(attempts: 1, success: true)
  end

  it 'announces the win with the attempt count' do
    feed(10, 42)

    expect { round.play }.to output(/You found it in 2 attempts!/).to_stdout
  end

  it 'gives a "too low" hint when the guess is below the number' do
    feed(10, 42)

    expect { round.play }.to output(/Too low!/).to_stdout
  end

  it 'gives a "too high" hint when the guess is above the number' do
    feed(80, 42)

    expect { round.play }.to output(/Too high!/).to_stdout
  end

  it 'shows the remaining attempts after a wrong guess' do
    feed(10, 42)

    expect { round.play }.to output(/Attempts remaining: 2/).to_stdout
  end

  it 'welcomes the player with the range bounds' do
    feed(42)

    expect { round.play }.to output(/Guess the number between 1 and 100!/).to_stdout
  end

  it 'returns a losing result after exhausting all attempts' do
    feed(10, 20, 30)

    expect(round.play).to have_attributes(attempts: 3, success: false)
  end

  it 'reveals the secret number on defeat' do
    feed(10, 20, 30)

    expect { round.play }.to output(/Game over! The number was 42\./).to_stdout
  end

  context 'with invalid guess input' do
    it 're-prompts on non-numeric input' do
      feed('abc', 42)

      expect { round.play }.to output(/Please enter a valid number\./).to_stdout
    end

    it 're-prompts on out-of-range input' do
      feed(101, 42)

      expect { round.play }.to output(/Please enter a number between 1 and 100\./).to_stdout
    end

    it 'does not count invalid entries as attempts' do
      feed('abc', 101, 42)

      expect(round.play).to have_attributes(attempts: 1)
    end

    it 'treats a negative guess as numeric but out of range' do
      feed(-5, 42)

      expect { round.play }.to output(/Please enter a number between 1 and 100\./).to_stdout
    end
  end
end
