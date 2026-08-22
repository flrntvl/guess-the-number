# frozen_string_literal: true

require 'json'

# Saves game results as JSON entries in data/results.json.
class Scoreboard
  def initialize(file_path = 'data/results.json')
    @file_path = file_path
  end

  # Appends a result hash to the stored list and rewrites the file.
  def save(result)
    results = load
    results << result
    File.write(@file_path, JSON.pretty_generate(results))
  end

  private

  # Returns an empty list when the file is missing or corrupted.
  def load
    return [] unless File.exist?(@file_path)

    parsed = JSON.parse(File.read(@file_path))
    parsed.is_a?(Array) ? parsed : []
  rescue JSON::ParserError
    []
  end
end
