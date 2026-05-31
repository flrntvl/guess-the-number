# frozen_string_literal: true

require_relative 'lib/game_session'
require_relative 'lib/game'
require_relative 'lib/messages'
require_relative 'lib/score_board'

difficulty, player = GameSession.new.run

game = Game.new(difficulty, player)
game.play

score_board = ScoreBoard.new
score_board.save(game.to_result)
score_board.display(difficulty, player.language)
