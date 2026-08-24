# frozen_string_literal: true

require 'console_menu'
require 'i18n'

RSpec.describe ConsoleMenu do
  # subject: the object under test, built fresh for each example.
  # `described_class` is ConsoleMenu; `menu` is lazily created on first use.
  subject(:menu) do
    described_class.new(
      title: title,
      options: options,
      prompt: 'Your choice: ',
      invalid_message: 'Invalid choice.'
    )
  end

  # let: lazy helper values — evaluated on first call within an example,
  # then memoized until the next one. Here they feed the subject above.
  let(:title) { 'Main menu:' }
  let(:options) { { play: 'Play', quit: 'Quit' } }

  # Plain helper method (not memoized): queues canned input lines so that
  # each $stdin.gets inside the menu returns the given values in order.
  def feed(*values)
    allow($stdin).to receive(:gets).and_return(*values.map { |value| "#{value}\n" })
  end

  it 'displays the title and numbered options' do
    feed('quit')

    expect { menu.select }.to output(
      a_string_matching(/Main menu:/)
        .and(a_string_matching(/^  1\. Play$/))
        .and(a_string_matching(/^  2\. Quit$/))
    ).to_stdout
  end

  it 'returns the chosen key when picked by menu number' do
    feed('1') # "1" is the first option in the hash

    expect(menu.select).to eq(:play)
  end

  it 'returns the chosen key when picked by option key' do
    feed('quit') # typed text matches a key of the options hash

    expect(menu.select).to eq(:quit)
  end

  it 'returns the chosen key when picked by option label, case-insensitive' do
    feed('PLAY') # typed text matches a displayed label, any casing

    expect(menu.select).to eq(:play)
  end

  it 're-prompts on an invalid choice until a valid one is given' do
    feed('de', '0', '99', '2') # unknown word, zero and out-of-range numbers are all rejected

    expect(menu.select).to eq(:quit) # the loop only ends once a valid choice is read
  end

  it 'warns with the invalid message on a bad choice' do
    feed('nonsense', 'quit')

    expect { menu.select }.to output(/Invalid choice\./).to_stdout
  end

  it 'raises EndOfInput when standard input closes' do
    allow($stdin).to receive(:gets).and_return(nil) # gets returning nil = Ctrl+D

    expect { menu.select }.to raise_error(EndOfInput)
  end

  context 'with string keys' do
    # Overrides the outer `options` just for this group: keys can be Strings.
    let(:options) { { 'easy' => 'Easy', 'hard' => 'Hard' } }

    it 'returns the chosen string key by menu number' do
      feed('2')

      expect(menu.select).to eq('hard') # the key type is preserved
    end
  end
end
