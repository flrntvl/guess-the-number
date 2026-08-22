# frozen_string_literal: true

require 'scoreboard'
require 'tmpdir'
require 'fileutils'

RSpec.describe Scoreboard do
  subject(:scoreboard) { described_class.new(file_path) }

  let(:file_path) { File.join(tmpdir, 'results.json') }
  let(:tmpdir) { Dir.mktmpdir }

  after { FileUtils.remove_entry(tmpdir) }

  def read_results
    JSON.parse(File.read(file_path), symbolize_names: true)
  end

  def write_results(results)
    File.write(file_path, JSON.generate(results))
  end

  describe '#top' do
    it 'returns only winning results sorted by attempts' do
      write_results([
        { player_name: 'Slow', difficulty: 'medium', attempts: 9, success: true },
        { player_name: 'Fast', difficulty: 'medium', attempts: 3, success: true },
        { player_name: 'Loser', difficulty: 'medium', attempts: 1, success: false }
      ])

      expect(scoreboard.top(:medium)).to eq([
        { player_name: 'Fast', difficulty: 'medium', attempts: 3, success: true },
        { player_name: 'Slow', difficulty: 'medium', attempts: 9, success: true }
      ])
    end

    it 'filters by difficulty' do
      write_results([
        { player_name: 'Easy winner', difficulty: 'easy', attempts: 2, success: true },
        { player_name: 'Hard winner', difficulty: 'hard', attempts: 2, success: true }
      ])

      expect(scoreboard.top(:hard).map { |entry| entry[:player_name] }).to eq(['Hard winner'])
    end

    it 'limits the number of entries' do
      write_results(Array.new(15) { |i| { player_name: "P#{i}", difficulty: 'easy', attempts: i + 1, success: true } })

      expect(scoreboard.top(:easy).size).to eq(Scoreboard::TOP_SIZE)
      expect(scoreboard.top(:easy).last[:attempts]).to eq(Scoreboard::TOP_SIZE)
    end

    it 'returns an empty list when nothing matches' do
      expect(scoreboard.top(:medium)).to eq([])
    end
  end

  describe '#save' do
    it 'creates the file with a list when it does not exist' do
      result = { player_name: 'Alice', success: true }

      scoreboard.save(result)

      expect(read_results).to eq([result])
    end

    it 'appends the result to the existing entries' do
      scoreboard.save(player_name: 'Alice', success: true)
      scoreboard.save(player_name: 'Bob', success: false)

      expect(read_results.map { |entry| entry[:player_name] }).to eq(%w[Alice Bob])
    end

    it 'starts from an empty list when the file is corrupted' do
      File.write(file_path, 'not json at all')

      scoreboard.save(player_name: 'Alice', success: true)

      expect(read_results).to eq([{ player_name: 'Alice', success: true }])
    end

    it 'starts from an empty list when the file does not contain a list' do
      File.write(file_path, '{"oops": true}')

      scoreboard.save(player_name: 'Alice', success: true)

      expect(read_results).to eq([{ player_name: 'Alice', success: true }])
    end

    it 'pretty-prints the JSON' do
      scoreboard.save(player_name: 'Alice')

      expect(File.read(file_path)).to include("  \"player_name\": \"Alice\"")
    end
  end
end
