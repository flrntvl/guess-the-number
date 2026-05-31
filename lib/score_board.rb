# frozen_string_literal: true

require 'json'
require_relative 'translations'

class ScoreBoard
  TABLE_WIDTH = 35
  RESULTS_FILE = 'data/results.json'

  class << self
    # @param result [Hash] game result from Game#to_result
    def save(result)
      scores = load_scores
      scores << result
      File.write(RESULTS_FILE, JSON.pretty_generate(scores))
    end

    # @param difficulty [Symbol] e.g. :easy, :medium, :hard
    def display(difficulty)
      results = load_scores
      leaderboard = filter_and_sort(results, difficulty)
      print_header
      leaderboard.each_with_index { |score, index| print_row(index, score) }
      print_separator
    end

    private

    # @return [Array<Hash{Symbol => Object}>] results with Symbol keys (e.g. r[:player_name])
    # symbolize_names: true converts JSON string keys to Symbols on parse
    def load_scores
      if File.exist?(RESULTS_FILE)
        JSON.parse(File.read(RESULTS_FILE), symbolize_names: true)
      else
        []
      end
    end

    # @param results [Array<Hash{Symbol => Object}>] Hashes with Symbol keys from load_scores
    # @param difficulty [Symbol] e.g. :easy, :medium, :hard
    # @return [Array<Hash{Symbol => Object}>] top 5 wins for the given difficulty
    def filter_and_sort(results, difficulty)
      results.select { |r| r[:success] && r[:difficulty] == difficulty.to_s }
             .sort_by { |r| [r[:attempts], r[:timestamp]] }
             .first(5)
    end

    def print_separator
      puts '─' * TABLE_WIDTH
    end

    def print_header
      puts Translation.t(:leaderboard)
      print_separator
      puts Translation.t(:leaderboard_header)
      print_separator
    end

    def print_row(index, score)
      rank = (index + 1).to_s.ljust(4)
      puts "#{rank}#{score[:player_name].ljust(12)}#{score[:attempts].to_s.ljust(10)}#{score[:difficulty]}"
    end
  end
end
