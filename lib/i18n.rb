# frozen_string_literal: true

# Translates UI messages with interpolation, falling back to English when needed.
class I18n
  TRANSLATIONS = {
    en: {
      difficulty_menu: 'Choose a difficulty level (enter its number or its name):',
      invalid_difficulty: 'Please enter a valid choice.',
      difficulty_easy: 'Easy',
      difficulty_medium: 'Medium',
      difficulty_hard: 'Hard',
      attempts_word: 'attempts',
      welcome: 'Guess the number between %<min>d and %<max>d!',
      guess_prompt: 'Your guess (%<min>d-%<max>d): ',
      invalid_number: 'Please enter a valid number.',
      out_of_range: 'Please enter a number between %<min>d and %<max>d.',
      too_low: 'Too low!',
      too_high: 'Too high!',
      remaining_attempts: 'Attempts remaining: %<count>d',
      win: 'You found it in %<attempts>d attempts!',
      loss: 'Game over! The number was %<number>d.'
    },
    fr: {
      difficulty_menu: 'Choisissez un niveau de difficulté (son numéro ou son nom) :',
      invalid_difficulty: 'Choix invalide.',
      difficulty_easy: 'Facile',
      difficulty_medium: 'Moyen',
      difficulty_hard: 'Difficile',
      attempts_word: 'tentatives',
      welcome: 'Devinez le nombre entre %<min>d et %<max>d !',
      guess_prompt: 'Votre essai (%<min>d-%<max>d) : ',
      invalid_number: 'Veuillez entrer un nombre valide.',
      out_of_range: 'Veuillez entrer un nombre entre %<min>d et %<max>d.',
      too_low: 'Trop petit !',
      too_high: 'Trop grand !',
      remaining_attempts: 'Essais restants : %<count>d',
      win: 'Vous avez trouvé en %<attempts>d tentative(s) !',
      loss: 'Perdu ! Le nombre était %<number>d.'
    }
  }.freeze

  LANGUAGES = {
    en: 'English',
    fr: 'Français'
  }.freeze

  DEFAULT_LANGUAGE = :en

  attr_reader :language

  def initialize(language = DEFAULT_LANGUAGE)
    @language = TRANSLATIONS.key?(language) ? language : DEFAULT_LANGUAGE
  end

  def t(key, **params)
    string = TRANSLATIONS.fetch(@language).fetch(key) do
      TRANSLATIONS.fetch(DEFAULT_LANGUAGE).fetch(key)
    end

    format(string, **params)
  end
end
