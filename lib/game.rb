# frozen_string_literal: true

require_relative 'console_input'
require_relative 'console_menu'
require_relative 'i18n'
require_relative 'language_selector'
require_relative 'leaderboard_presenter'
require_relative 'player'
require_relative 'round'
require_relative 'scoreboard'

# Runs a number guessing game: main menu, difficulty selection, guessing loop and result display.
class Game
  include ConsoleInput

  DIFFICULTIES = {
    easy: { range: (1..50), max_attempts: 20 },
    medium: { range: (1..100), max_attempts: 15 },
    hard: { range: (1..500), max_attempts: 10 }
  }.freeze

  MAIN_ACTIONS = {
    play: :action_play,
    leaderboard: :action_leaderboard,
    quit: :action_quit
  }.freeze

  TIMESTAMP_FORMAT = '%Y-%m-%d %H:%M:%S %z'

  def initialize(language_selector: LanguageSelector.new, scoreboard: Scoreboard.new, random: Random)
    @language_selector = language_selector
    @scoreboard = scoreboard
    @random = random
  end

  def start
    puts
    puts '=== Guess the Number ==='
    puts

    main_menu_loop
    puts
    puts t(:goodbye)
  rescue EndOfInput
    # Standard input closed (e.g. Ctrl+D): exit gracefully.
    # The language may not be chosen yet, so fall back to the default one.
    @i18n ||= I18n.new
    puts
    puts t(:goodbye)
  end

  private

  # Runs the main menu loop until the player quits.
  def main_menu_loop
    @i18n = I18n.new(@language_selector.select)
    @presenter = LeaderboardPresenter.new(@i18n, @scoreboard, DIFFICULTIES.keys)

    loop do
      action = ask_main_action
      break if action == :quit

      play_round if action == :play
      @presenter.display if action == :leaderboard
    end
  end

  def t(key, **params)
    @i18n.t(key, **params)
  end

  # Asks for the next main-menu action via the shared console menu.
  def ask_main_action
    ConsoleMenu.new(
      title: "\n#{t(:main_menu_title)}",
      options: MAIN_ACTIONS.transform_values { |label_key| t(label_key) },
      prompt: t(:choice_prompt),
      invalid_message: t(:invalid_action)
    ).select
  end

  # Runs one guessing round: player setup, difficulty selection, the round
  # itself, then saves the outcome and shows the leaderboard.
  def play_round
    @player = Player.ask(i18n: @i18n)
    puts t(:hello, name: @player.name)

    difficulty = ask_difficulty
    result = run_round(difficulty)

    save_result(difficulty, result)
    @presenter.display
  end

  # Draws a number for the chosen difficulty and plays the round.
  def run_round(difficulty)
    settings = DIFFICULTIES[difficulty]
    number = generate_number(settings[:range])

    Round.new(
      range: settings[:range],
      max_attempts: settings[:max_attempts],
      number: number,
      i18n: @i18n
    ).play
  end

  # Builds the game result hash and stores it on the scoreboard.
  def save_result(difficulty, result)
    @scoreboard.save(
      player_name: @player.name,
      difficulty: difficulty.to_s,
      attempts: result.attempts,
      language: @i18n.language.to_s,
      number_to_guess: result.number_to_guess,
      success: result.success,
      timestamp: Time.now.strftime(TIMESTAMP_FORMAT)
    )
  end

  # Asks for the difficulty level via the shared console menu.
  def ask_difficulty
    ConsoleMenu.new(
      title: t(:difficulty_menu),
      options: difficulty_options,
      prompt: t(:choice_prompt),
      invalid_message: t(:invalid_difficulty)
    ).select.to_sym
  end

  # Builds the translated menu labels for each difficulty.
  def difficulty_options
    DIFFICULTIES.keys.to_h do |name|
      settings = DIFFICULTIES[name]
      label = "#{t(:"difficulty_#{name}")} (1-#{settings[:range].last}, " \
              "#{settings[:max_attempts]} #{t(:attempts_word)})"
      [name.to_s, label]
    end
  end

  def generate_number(range)
    @random.rand(range)
  end
end
