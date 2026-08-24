# frozen_string_literal: true

require_relative 'console_input'
require_relative 'i18n'

# Asks the player to choose the game language from console input.
class LanguageSelector
  TITLE = "Choose your language / Choisissez votre langue :\n" \
          '(e.g. 1, en or English / ex. 2, fr ou Français)'
  INVALID_CHOICE = 'Invalid choice / Choix invalide.'

  # The prompt stays bilingual: no I18n exists yet, since this menu is what
  # produces it.
  def select
    ConsoleMenu.new(
      title: TITLE,
      options: I18n::LANGUAGES,
      prompt: '> ',
      invalid_message: INVALID_CHOICE
    ).select
  end
end
