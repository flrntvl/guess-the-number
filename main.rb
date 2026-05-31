# frozen_string_literal: true

require_relative 'lib/game_session'
require_relative 'lib/translations'

Translation.select_language
GameSession.new.run
