# frozen_string_literal: true

require 'player'

RSpec.describe Player do
  subject(:player) { described_class.new('Alice') }

  it 'exposes its name' do
    expect(player.name).to eq('Alice')
  end
end
