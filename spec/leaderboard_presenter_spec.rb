# frozen_string_literal: true

require 'i18n'
require 'leaderboard_presenter'
require 'scoreboard'

RSpec.describe LeaderboardPresenter do
  subject(:presenter) { described_class.new(i18n, scoreboard, %i[medium]) }

  let(:i18n) { I18n.new(language) }
  let(:scoreboard) { instance_double(Scoreboard) }
  let(:language) { :en }

  describe '#display' do
    it 'displays ranked rows for each difficulty section' do
      allow(scoreboard).to receive(:top).with(:medium).and_return([
        { player_name: 'Alice', difficulty: 'medium', attempts: 4 },
        { player_name: 'Bob', difficulty: 'medium', attempts: 7 }
      ])

      expect { presenter.display }.to output(
        a_string_matching(/Top scores — Medium/)
          .and(a_string_matching(/^ 1\. Alice\s+4 attempts$/))
          .and(a_string_matching(/^ 2\. Bob\s+7 attempts$/))
      ).to_stdout
    end

    it 'displays a message when there are no scores' do
      allow(scoreboard).to receive(:top).with(:medium).and_return([])

      expect { presenter.display }.to output(/No scores yet\./).to_stdout
    end

    it 'displays translated sections in French' do
      allow(scoreboard).to receive(:top).with(:medium).and_return([
        { player_name: 'Alice', difficulty: 'medium', attempts: 4 }
      ])
      french_presenter = described_class.new(I18n.new(:fr), scoreboard, %i[medium])

      expect { french_presenter.display }.to output(
        a_string_matching(/Meilleurs scores — Moyen/)
          .and(a_string_matching(/^ 1\. Alice\s+4 tentatives$/))
      ).to_stdout
    end
  end
end
