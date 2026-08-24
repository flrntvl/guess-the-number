# frozen_string_literal: true

require_relative 'console_input'

# Generic console menu: displays numbered options, reads the player's choice,
# resolves it (menu number, option key or option label) and re-prompts until
# the choice matches an option.
class ConsoleMenu
  include ConsoleInput

  # Options are given as a hash { key => displayed label }, labels being
  # already translated by the caller.
  def initialize(title:, options:, prompt:, invalid_message:)
    @title = title
    @options = options
    @prompt = prompt
    @invalid_message = invalid_message
  end

  # Displays the menu and loops until the player picks a valid option.
  # Returns the chosen option key.
  def select
    loop do
      display
      print @prompt
      choice = resolve(read_input.downcase)
      return choice if choice

      puts @invalid_message
    end
  end

  private

  def display
    puts @title
    @options.each_with_index { |(_, label), index| puts "  #{index + 1}. #{label}" }
  end

  # Resolves the raw player input (menu number, option key or option label,
  # case-insensitive) into an option key, or nil when it matches nothing.
  def resolve(input)
    if input.match?(/\A\d+\z/)
      index = input.to_i - 1
      return @options.keys[index] if index >= 0
    end

    @options.each do |key, label|
      return key if key.to_s == input || label.downcase == input
    end

    nil
  end
end
