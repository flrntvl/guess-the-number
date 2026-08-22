# frozen_string_literal: true

require 'language_selector'

RSpec.describe LanguageSelector do
  subject(:selector) { described_class.new }

  def select_with(*inputs)
    allow(selector).to receive(:gets).and_return(*inputs.map { |value| "#{value}\n" })
  end

  describe '#select' do
    it 'displays the language menu' do
      select_with('1')

      expect { selector.select }.to output(
        a_string_matching(/Choose your language \/ Choisissez votre langue :/)
          .and(a_string_matching(/\(e\.g\. 1, en or English \/ ex\. 2, fr ou Français\)/))
          .and(a_string_matching(/^  1\. English$/))
          .and(a_string_matching(/^  2\. Français$/))
      ).to_stdout
    end

    it 'accepts a language chosen by menu number' do
      select_with('2')

      language = nil
      expect { language = selector.select }.to output(/2\. Français/).to_stdout

      expect(language).to eq(:fr)
    end

    it 'accepts a language chosen by name' do
      select_with('English')

      language = nil
      expect { language = selector.select }.to output(/2\. Français/).to_stdout

      expect(language).to eq(:en)
    end

    it 'accepts a language chosen by code' do
      select_with('fr')

      language = nil
      expect { language = selector.select }.to output(/2\. Français/).to_stdout

      expect(language).to eq(:fr)
    end

    it 're-prompts on an invalid choice until a valid one is given' do
      select_with('de', '0', '99', 'en')

      language = nil
      expect { language = selector.select }.to output(/Invalid choice \/ Choix invalide\./).to_stdout

      expect(language).to eq(:en)
    end

    it 'warns on an invalid choice' do
      select_with('de', 'en')

      expect { selector.select }.to output(/Invalid choice \/ Choix invalide\./).to_stdout
    end

    it 'raises EndOfInput when standard input closes' do
      allow(selector).to receive(:gets).and_return(nil)

      expect { selector.select }.to raise_error(EndOfInput)
    end
  end
end
