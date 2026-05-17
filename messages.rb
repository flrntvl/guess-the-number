# frozen_string_literal: true

LANGUAGES = {
  en: {
    welcome: 'Welcome to the Number Guessing Game!',
    select_language: 'Select a language: (en, fr)',
    select_difficulty: 'Select a difficulty level: (easy, medium, hard)',
    thinking: 'I\'m thinking of a number between %s and %s. Can you guess it?',
    too_low: 'Too low! Try again.',
    too_high: 'Too high! Try again.',
    win: 'Congratulations! You\'ve guessed the number in %s attempts!',
    lose: 'Sorry, you\'ve used all %s attempts. The number was %s.'
  },
  fr: {
    welcome: 'Bienvenue dans le jeu du nombre mystère !',
    select_language: 'Sélectionnez une langue : (en, fr)',
    select_difficulty: 'Choisissez un niveau : (easy, medium, hard)',
    thinking: 'Je pense à un nombre entre %s et %s. Devinez !',
    too_low: 'Trop bas ! Réessayez.',
    too_high: 'Trop haut ! Réessayez.',
    win: 'Bravo ! Vous avez trouvé en %s tentatives !',
    lose: 'Désolé, vous avez utilisé %s tentatives. Le nombre était %s.'
  }
}.freeze
