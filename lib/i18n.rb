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
      name_prompt: 'Enter your name: ',
      empty_name: 'Please enter a name.',
      hello: 'Hello %<name>s!',
      welcome: 'Guess the number between %<min>d and %<max>d!',
      guess_prompt: 'Your guess (%<min>d-%<max>d): ',
      invalid_number: 'Please enter a valid number.',
      out_of_range: 'Please enter a number between %<min>d and %<max>d.',
      too_low: 'Too low!',
      too_high: 'Too high!',
      remaining_attempts: 'Attempts remaining: %<count>d',
      main_menu_title: 'Main menu:',
      choice_prompt: 'Your choice: ',
      action_play: 'Play',
      action_leaderboard: 'Leaderboard',
      action_quit: 'Quit',
      invalid_action: 'Please enter a valid choice.',
      leaderboard_title: 'Top scores — %<difficulty>s',
      no_scores: 'No scores yet.',
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
      name_prompt: 'Entrez votre nom : ',
      empty_name: 'Veuillez entrer un nom.',
      hello: 'Bonjour %<name>s !',
      welcome: 'Devinez le nombre entre %<min>d et %<max>d !',
      guess_prompt: 'Votre essai (%<min>d-%<max>d) : ',
      invalid_number: 'Veuillez entrer un nombre valide.',
      out_of_range: 'Veuillez entrer un nombre entre %<min>d et %<max>d.',
      too_low: 'Trop petit !',
      too_high: 'Trop grand !',
      remaining_attempts: 'Essais restants : %<count>d',
      main_menu_title: 'Menu principal :',
      choice_prompt: 'Votre choix : ',
      action_play: 'Jouer',
      action_leaderboard: 'Classement',
      action_quit: 'Quitter',
      invalid_action: 'Choix invalide.',
      leaderboard_title: 'Meilleurs scores — %<difficulty>s',
      no_scores: 'Aucun score pour le moment.',
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
