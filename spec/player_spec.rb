# frozen_string_literal: true

require 'player'
require 'i18n'

RSpec.describe Player do
  describe '.ask' do
    # Helper: queues the answers typed at the name prompt.
    def feed(*values)
      allow($stdin).to receive(:gets).and_return(*values.map { |value| "#{value}\n" })
    end

    it 'returns a Player built from the entered name' do
      feed('Alice')

      # .ask is a class method: it prompts, then wraps the answer.
      player = described_class.ask(i18n: I18n.new(:en))

      expect(player.name).to eq('Alice')
    end

    it 're-prompts on an empty name until a valid one is given' do
      feed('', '   ', 'Alice') # blank and whitespace-only are both rejected

      player = nil
      expect { player = described_class.ask(i18n: I18n.new(:en)) }
        .to output(/Please enter a name\./).to_stdout

      expect(player.name).to eq('Alice') # loop only ends on a non-empty name
    end

    it 'uses the selected language for the prompts' do
      feed('Bob')

      player = nil
      expect { player = described_class.ask(i18n: I18n.new(:fr)) }
        .to output(/Entrez votre nom :/).to_stdout

      expect(player.name).to eq('Bob')
    end
  end

  describe '#initialize' do
    it 'exposes its name' do
      # Plain value object: what goes in comes back out.
      expect(described_class.new('Alice').name).to eq('Alice')
    end
  end
end
