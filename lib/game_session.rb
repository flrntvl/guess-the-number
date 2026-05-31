# frozen_string_literal: true

require_relative 'difficulty'
require_relative 'translations'
require_relative 'player'
require_relative 'game'
require_relative 'score_board'

# Coordinates the flow of a game session: player setup and game orchestration.
class GameSession
  def run
    puts Translation.t(:welcome)
    @player = create_player
    last_difficulty = nil
    loop do
      last_difficulty = play_round
      break unless play_again?
    end
    ScoreBoard.display(last_difficulty)
  end

  private

  # @return [Symbol] e.g. :easy, :medium, :hard
  def select_difficulty
    difficulty = nil

    until DIFFICULTY_LEVELS.key?(difficulty)
      puts Translation.t(:select_difficulty)
      difficulty = gets.chomp.downcase.to_sym
    end

    difficulty
  end

  # @return [Player] instance of Player with the entered name
  def create_player
    puts Translation.t(:ask_name)
    name = gets.chomp
    Player.new(name)
  end

  # @return [Boolean] true if the player wants to play again
  def play_again?
    answer = nil
    until Translation.t(:yes_no_valid).include?(answer)
      puts Translation.t(:play_again)
      answer = gets.chomp.downcase
    end
    Translation.t(:yes_answers).include?(answer)
  end

  # @return [Symbol] the difficulty played, for use by the final scoreboard display
  def play_round
    difficulty = select_difficulty
    game = Game.new(difficulty, @player)
    game.play
    ScoreBoard.save(game.to_result)
    difficulty
  end
end
