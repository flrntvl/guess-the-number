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
