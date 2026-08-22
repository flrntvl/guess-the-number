# frozen_string_literal: true

require_relative 'i18n'
require_relative 'scoreboard'

# Formats and displays the leaderboard sections for all difficulties.
class LeaderboardPresenter
  SEPARATOR = '-' * 40

  def initialize(i18n, scoreboard, difficulties)
    @i18n = i18n
    @scoreboard = scoreboard
    @difficulties = difficulties
  end

  def display
    puts
    @difficulties.each { |difficulty| display_section(difficulty) }
  end

  private

  def t(key, **params)
    @i18n.t(key, **params)
  end

  def display_section(difficulty)
    puts SEPARATOR
    puts t(:leaderboard_title, difficulty: t(:"difficulty_#{difficulty}"))
    puts SEPARATOR
    top_scores = @scoreboard.top(difficulty)

    if top_scores.empty?
      puts t(:no_scores)
    else
      display_rows(top_scores)
    end
    puts
  end

  def display_rows(top_scores)
    top_scores.each_with_index do |result, index|
      rank = "#{index + 1}."
      name = result[:player_name].ljust(15)
      attempts = result[:attempts].to_s.rjust(3)

      puts " #{rank} #{name} #{attempts} #{t(:attempts_word)}"
    end
  end
end
