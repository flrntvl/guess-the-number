# frozen_string_literal: true

DIFFICULTY_LEVELS = {
  easy: { attempts: 15, range: 1..50 },
  medium: { attempts: 10, range: 1..100 },
  hard: { attempts: 5, range: 1..200 }
}.freeze
