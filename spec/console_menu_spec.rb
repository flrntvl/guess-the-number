# frozen_string_literal: true

require 'console_menu'
require 'i18n'

RSpec.describe ConsoleMenu do
  subject(:menu) do
    described_class.new(
      title: title,
      options: options,
      prompt: 'Your choice: ',
      invalid_message: 'Invalid choice.'
    )
  end

  let(:title) { 'Main menu:' }
  let(:options) { { play: 'Play', quit: 'Quit' } }

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
    feed('1')

    expect(menu.select).to eq(:play)
  end

  it 'returns the chosen key when picked by option key' do
    feed('quit')

    expect(menu.select).to eq(:quit)
  end

  it 'returns the chosen key when picked by option label, case-insensitive' do
    feed('PLAY')

    expect(menu.select).to eq(:play)
  end

  it 're-prompts on an invalid choice until a valid one is given' do
    feed('de', '0', '99', '2')

    expect(menu.select).to eq(:quit)
  end

  it 'warns with the invalid message on a bad choice' do
    feed('nonsense', 'quit')

    expect { menu.select }.to output(/Invalid choice\./).to_stdout
  end

  it 'raises EndOfInput when standard input closes' do
    allow($stdin).to receive(:gets).and_return(nil)

    expect { menu.select }.to raise_error(EndOfInput)
  end

  context 'with string keys' do
    let(:options) { { 'easy' => 'Easy', 'hard' => 'Hard' } }

    it 'returns the chosen string key by menu number' do
      feed('2')

      expect(menu.select).to eq('hard')
    end
  end
end
