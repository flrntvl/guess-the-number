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
      # subject: a translator whose FR table is missing some keys on purpose.
      subject(:translator) { described_class.new(:fr, translations: partial_translations) }

      # Deliberately partial: `win` exists only in EN, to exercise the fallback.
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

    describe 'translation completeness' do
      # Guards against a key being added to the English reference table but
      # forgotten in another language: every supported language must be able
      # to display any menu without silently falling back.
      it 'defines every English key in every supported language' do
        reference_keys = I18n::TRANSLATIONS[:en].keys

        I18n::LANGUAGES.each_key do |lang|
          missing = reference_keys - I18n::TRANSLATIONS[lang].keys

          expect(missing).to be_empty,
                             "missing translations in #{lang}: #{missing.join(', ')}"
        end
      end
    end
  end
end
