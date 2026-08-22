# frozen_string_literal: true

require 'json'

# Saves game results as JSON entries in data/results.json.
class Scoreboard
  TOP_SIZE = 10

  def initialize(file_path = 'data/results.json')
    @file_path = file_path
  end

  # Appends a result hash to the stored list and rewrites the file.
  def save(result)
    results = entries
    results << result
    File.write(@file_path, JSON.pretty_generate(results))
  end

  # Returns the best winning results for a difficulty, sorted by attempts.
  def top(difficulty, limit = TOP_SIZE)
    entries.select { |result| result[:success] && result[:difficulty] == difficulty.to_s }
           .sort_by { |result| result[:attempts] }
           .first(limit)
  end

  private

  # Returns an empty list when the file is missing or corrupted.
  def entries
    return [] unless File.exist?(@file_path)

    parsed = JSON.parse(File.read(@file_path), symbolize_names: true)
    parsed.is_a?(Array) ? parsed : []
  rescue JSON::ParserError
    []
  end
end
