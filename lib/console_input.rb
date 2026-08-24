# frozen_string_literal: true

require_relative 'end_of_input'

# Shared console-reading logic for all interactive classes.
#
# Centralizes how a line is read and normalized (invalid bytes scrubbed,
# surrounding whitespace stripped) and turns end-of-input into a single
# EndOfInput signal that callers handle in one place.
module ConsoleInput
  # Reads one line from the given IO (standard input by default).
  # Raises EndOfInput when the stream is closed (gets returns nil).
  def read_input(io = $stdin)
    input = io.gets

    raise EndOfInput if input.nil?

    input.chomp.scrub.strip
  end
end
