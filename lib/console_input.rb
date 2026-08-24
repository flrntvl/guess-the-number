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

  # Also expose the method at module level (ConsoleInput.read_input), so
  # class methods like Player.ask can use it without an instance. Included
  # classes keep calling it as before.
  module_function :read_input
end
