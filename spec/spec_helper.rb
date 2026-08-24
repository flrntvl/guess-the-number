# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))

begin
  require 'simplecov'
  SimpleCov.start do
    skip '/spec/'
  end
rescue LoadError
  nil
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.disable_monkey_patching!
  config.order = :random
  Kernel.srand config.seed

  # Silence console output from production code under test. Examples that
  # assert on output still work: RSpec's `output` matcher swaps $stdout
  # itself inside the block, then restores this buffer.
  config.around do |example|
    original_stdout = $stdout
    $stdout = StringIO.new
    example.run
  ensure
    $stdout = original_stdout
  end
end
