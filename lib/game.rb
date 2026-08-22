# frozen_string_literal: true

require_relative 'i18n'
require_relative 'language_selector'
require_relative 'leaderboard_presenter'
require_relative 'player'
require_relative 'scoreboard'

# Runs a number guessing game: main menu, difficulty selection, guessing loop and result display.
class Game
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

  def initialize(language_selector: LanguageSelector.new, scoreboard: Scoreboard.new)
    @language_selector = language_selector
    @scoreboard = scoreboard
  end

  def start
    puts
    puts '=== Guess the Number ==='
    puts
    @i18n = I18n.new(@language_selector.select)
    @presenter = LeaderboardPresenter.new(@i18n, @scoreboard, DIFFICULTIES.keys)

    loop do
      action = ask_main_action
      break if action == :quit

      play_round if action == :play
      @presenter.display if action == :leaderboard
    end
  end

  private

  def t(key, **params)
    @i18n.t(key, **params)
  end

  # Reads console input, replacing invalid byte sequences.
  def read_input
    gets.chomp.scrub.strip
  end

  # Asks for the next action in the main menu.
  def ask_main_action
    loop do
      display_main_menu
      print t(:choice_prompt)
      action = resolve_main_action(gets.chomp.strip.downcase)
      return action if action

      puts t(:invalid_action)
    end
  end

  def display_main_menu
    puts
    puts t(:main_menu_title)
    MAIN_ACTIONS.each_with_index do |(_, label_key), index|
      puts "  #{index + 1}. #{t(label_key)}"
    end
  end

  # Resolves the raw player input (menu number or action name)
  # into a main action symbol, or nil when it matches nothing.
  def resolve_main_action(input)
    # Menu number: "1" selects the first action in the list.
    if input.match?(/\A\d+\z/)
      index = input.to_i - 1
      return MAIN_ACTIONS.keys[index] if index >= 0
    end

    # Action name ("play"), case-insensitive.
    input.to_sym if MAIN_ACTIONS.key?(input.to_sym)
  end

  def play_round
    @player = Player.new(ask_name)
    puts t(:hello, name: @player.name)

    difficulty = ask_difficulty
    @range = DIFFICULTIES[difficulty][:range]
    @max_attempts = DIFFICULTIES[difficulty][:max_attempts]

    number = generate_number
    attempts = 0
    success = false

    display_welcome

    loop do
      guess = ask_guess
      attempts += 1

      if correct?(guess, number)
        success = true
        display_win(attempts)
        break
      elsif attempts >= @max_attempts
        display_loss(number)
        break
      else
        display_hint(guess, number)
        display_remaining_attempts(attempts)
      end
    end

    save_result(difficulty, number, attempts, success)
    @presenter.display
  end

  # Asks for a non-empty player name.
  def ask_name
    loop do
      print t(:name_prompt)
      name = read_input
      return name unless name.empty?

      puts t(:empty_name)
    end
  end

  # Builds the game result hash and stores it on the scoreboard.
  def save_result(difficulty, number, attempts, success)
    @scoreboard.save(
      player_name: @player.name,
      difficulty: difficulty.to_s,
      attempts: attempts,
      language: @i18n.language.to_s,
      number_to_guess: number,
      success: success,
      timestamp: Time.now.strftime('%Y-%m-%d %H:%M:%S %z')
    )
  end

  def ask_difficulty
    loop do
      display_difficulty_menu
      print t(:choice_prompt)
      difficulty = resolve_difficulty(read_input.downcase)
      return difficulty if difficulty

      puts t(:invalid_difficulty)
    end
  end

  def display_difficulty_menu
    puts t(:difficulty_menu)
    DIFFICULTIES.each_with_index do |(name, settings), index|
      translated_name = t(:"difficulty_#{name}")
      puts "  #{index + 1}. #{translated_name} (1-#{settings[:range].last}, #{settings[:max_attempts]} #{t(:attempts_word)})"
    end
  end

  # Resolves the raw player input (menu number or difficulty name)
  # into a difficulty symbol, or nil when it matches nothing.
  def resolve_difficulty(input)
    # Menu number: "1" selects the first difficulty in the list.
    if input.match?(/\A\d+\z/)
      index = input.to_i - 1
      return DIFFICULTIES.keys[index] if index >= 0
    end

    # Difficulty name ("easy"), case-insensitive.
    input.to_sym if DIFFICULTIES.key?(input.to_sym)
  end

  def generate_number
    rand(@range)
  end

  def display_welcome
    puts t(:welcome, min: @range.first, max: @range.last)
  end

  def ask_guess
    loop do
      print t(:guess_prompt, min: @range.first, max: @range.last)
      input = read_input

      next puts t(:invalid_number) unless input.match?(/\A-?\d+\z/)

      guess = input.to_i
      return guess if @range.include?(guess)

      puts t(:out_of_range, min: @range.first, max: @range.last)
    end
  end

  def correct?(guess, number)
    guess == number
  end

  def display_hint(guess, number)
    puts guess < number ? t(:too_low) : t(:too_high)
  end

  def display_remaining_attempts(attempts)
    puts t(:remaining_attempts, count: @max_attempts - attempts)
  end

  def display_win(attempts)
    puts t(:win, attempts: attempts)
  end

  def display_loss(number)
    puts t(:loss, number: number)
  end
end
