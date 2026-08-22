# frozen_string_literal: true

require_relative 'i18n'

# Asks the player to choose the game language from console input.
class LanguageSelector
  def select
    loop do
      puts 'Choose your language / Choisissez votre langue :'
      puts '(e.g. 1, en or English / ex. 2, fr ou Français)'
      I18n::LANGUAGES.values.each_with_index { |label, index| puts "  #{index + 1}. #{label}" }
      print '> '
      language = resolve(read_input.downcase)
      return language if language

      puts 'Invalid choice / Choix invalide.'
    end
  end

  private

  # Reads console input, replacing invalid byte sequences.
  def read_input
    gets.chomp.scrub.strip
  end

  # Resolves the raw player input (menu number, language code or name)
  # into a language symbol, or nil when it matches nothing.
  def resolve(input)
    # Menu number: "1" selects the first language in the list.
    if input.match?(/\A\d+\z/)
      index = input.to_i - 1
      return I18n::LANGUAGES.keys[index] if index >= 0
    end

    # Language code ("en") or full name ("English"), case-insensitive.
    I18n::LANGUAGES.each do |code, label|
      return code if code.to_s == input || label.downcase == input
    end

    nil
  end
end
