# frozen_string_literal: true

require_relative 'end_of_input'

# Reads console input shared by all interactive prompts, replacing invalid byte sequences.
module ConsoleInput
  # Raises EndOfInput when standard input is closed (gets returns nil).
  def read_input
    input = gets
    raise EndOfInput if input.nil?

    input.chomp.scrub.strip
  end
end
