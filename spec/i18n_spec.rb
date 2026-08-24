# frozen_string_literal: true

require 'i18n'

RSpec.describe I18n do
  describe '#initialize' do
    it 'defaults to English' do
      expect(described_class.new.language).to eq(:en)
    end

    it 'accepts a supported language' do
      expect(described_class.new(:fr).language).to eq(:fr)
    end

    it 'falls back to English for an unsupported language' do
      expect(described_class.new(:de).language).to eq(:en)
    end
  end

  describe '#t' do
    it 'translates a key in the selected language' do
      expect(described_class.new(:fr).t(:too_low)).to eq('Trop petit !')
    end

    it 'interpolates parameters' do
      expect(described_class.new(:en).t(:win, attempts: 3)).to eq('You found it in 3 attempts!')
    end

    it 'interpolates several parameters' do
      translator = described_class.new(:fr)

      expect(translator.t(:out_of_range, min: 1, max: 50)).to eq('Veuillez entrer un nombre entre 1 et 50.')
    end

    describe 'per-key fallback to English' do
      subject(:translator) { described_class.new(:fr, translations: partial_translations) }

      let(:partial_translations) do
        {
          en: { too_low: 'Too low!', win: 'You found it in %<attempts>d attempts!' },
          fr: { too_low: 'Trop petit !' }
        }
      end

      it 'uses the selected language when the key exists' do
        expect(translator.t(:too_low)).to eq('Trop petit !')
      end

      it 'falls back to the English string when the key is missing' do
        expect(translator.t(:win, attempts: 3)).to eq('You found it in 3 attempts!')
      end

      it 'falls back for an entirely missing language' do
        de = described_class.new(:de, translations: partial_translations)

        expect(de.t(:too_low)).to eq('Too low!')
      end
    end
  end
end
