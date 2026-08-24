# frozen_string_literal: true

require 'fileutils'
require 'json'

# Saves game results as JSON entries in data/results.json.
class Scoreboard
  TOP_SIZE = 10

  def initialize(file_path = 'data/results.json')
    @file_path = file_path
  end

  # Appends a result hash to the stored list, writing atomically: the new
  # content goes to a temporary file that then replaces the target in one
  # rename, so a crash mid-write can never leave a truncated JSON behind.
  def save(result)
    results = entries
    results << result
    write_atomically(JSON.pretty_generate(results))
  end

  # Returns the best winning results for a difficulty, sorted by attempts
  # (earliest first when tied, via the timestamp).
  def top(difficulty, limit = TOP_SIZE)
    entries.select { |result| result[:success] && result[:difficulty] == difficulty.to_s }
           .sort_by { |result| [result[:attempts], result[:timestamp]] }
           .first(limit)
  end

  private

  def write_atomically(content)
    temp_path = "#{@file_path}.tmp"
    File.write(temp_path, content)
    File.rename(temp_path, @file_path)
  ensure
    FileUtils.rm_f(temp_path)
  end

  # Returns an empty list when the file is missing or corrupted.
  def entries
    return [] unless File.exist?(@file_path)

    parsed = JSON.parse(File.read(@file_path), symbolize_names: true)
    parsed.is_a?(Array) ? parsed : []
  rescue JSON::ParserError
    []
  end
end
