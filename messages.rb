# frozen_string_literal: true

LANGUAGES = {
  en: {
    welcome: 'Welcome to the Number Guessing Game!',
    select_language: 'Select a language: (en, fr)',
    ask_name: 'What is your name?',
    select_difficulty: 'Select a difficulty level: (easy, medium, hard)',
    thinking: 'I\'m thinking of a number between %s and %s. Can you guess it?',
    too_low: 'Too low! Try again.',
    too_high: 'Too high! Try again.',
    win: 'Congratulations! You\'ve guessed the number in %s attempts!',
    lose: 'Sorry, you\'ve used all %s attempts. The number was %s.',
    leaderboard: '🏆 Leaderboard:',
    leaderboard_header: "#{'#'.ljust(4)}#{'Player'.ljust(12)}#{'Attempts'.ljust(10)}Level"
  },
  fr: {
    welcome: 'Bienvenue dans le jeu du nombre mystère !',
    select_language: 'Sélectionnez une langue : (en, fr)',
    ask_name: 'Quel est votre nom ?',
    select_difficulty: 'Choisissez un niveau : (easy, medium, hard)',
    thinking: 'Je pense à un nombre entre %s et %s. Devinez !',
    too_low: 'Trop bas ! Réessayez.',
    too_high: 'Trop haut ! Réessayez.',
    win: 'Bravo ! Vous avez trouvé en %s tentatives !',
    lose: 'Désolé, vous avez utilisé %s tentatives. Le nombre était %s.',
    leaderboard: '🏆 Classement :',
    leaderboard_header: "#{'#'.ljust(4)}#{'Joueur'.ljust(12)}#{'Tentatives'.ljust(12)}Niveau"
  }
}.freeze
