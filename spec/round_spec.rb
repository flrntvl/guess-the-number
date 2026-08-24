# frozen_string_literal: true

require 'round'
require 'i18n'

RSpec.describe Round do
  # subject: the object under test, rebuilt before every `it` so examples
  # stay independent from each other.
  subject(:round) do
    described_class.new(
      range: range,
      max_attempts: max_attempts,
      number: number,
      i18n: I18n.new(:en)
    )
  end

  let(:range) { 1..100 }   # allowed guesses
  let(:max_attempts) { 3 } # small on purpose: easy to exhaust in a test
  let(:number) { 42 }      # the secret number for every example here

  # Helper (not memoized): queues the player's typed answers.
  def feed(*values)
    allow($stdin).to receive(:gets).and_return(*values.map { |value| "#{value}\n" })
  end

  # Helper: runs the block and returns everything it printed to stdout.
  def capture
    original = $stdout
    $stdout = StringIO.new
    yield
    $stdout.string
  ensure
    $stdout = original
  end

  it 'returns a winning result on the correct guess' do
    feed(42)

    # The contract of play is its return value — no output assertion needed.
    expect(round.play).to have_attributes(attempts: 1, success: true)
  end

  it 'announces the win with the attempt count' do
    feed(10, 42) # first guess wrong, second wins => "2 attempts"

    expect(capture { round.play }).to include('You found it in 2 attempts!')
  end

  it 'gives a "too low" hint when the guess is below the number' do
    feed(10, 42)

    expect(capture { round.play }).to include('Too low!')
  end

  it 'gives a "too high" hint when the guess is above the number' do
    feed(80, 42)

    expect(capture { round.play }).to include('Too high!')
  end

  it 'shows the remaining attempts after a wrong guess' do
    feed(10, 42) # one wrong guess out of three allowed

    expect(capture { round.play }).to include('Attempts remaining: 2')
  end

  it 'welcomes the player with the range bounds' do
    feed(42)

    expect(capture { round.play }).to include('Guess the number between 1 and 100!')
  end

  it 'returns a losing result after exhausting all attempts' do
    feed(10, 20, 30) # three wrong guesses = exactly max_attempts

    expect(round.play).to have_attributes(attempts: 3, success: false)
  end

  it 'reveals the secret number on defeat' do
    feed(10, 20, 30)

    expect(capture { round.play }).to include('Game over! The number was 42.')
  end

  context 'with invalid guess input' do
    it 're-prompts on non-numeric input' do
      feed('abc', 42)

      expect(capture { round.play }).to include('Please enter a valid number.')
    end

    it 're-prompts on out-of-range input' do
      feed(101, 42)

      expect(capture { round.play }).to include('Please enter a number between 1 and 100.')
    end

    it 'does not count invalid entries as attempts' do
      feed('abc', 101, 42) # two rejected entries, only "42" counts

      expect(round.play).to have_attributes(attempts: 1)
    end

    it 'treats a negative guess as numeric but out of range' do
      feed(-5, 42)

      expect(capture { round.play }).to include('Please enter a number between 1 and 100.')
    end
  end
end
