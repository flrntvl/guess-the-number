# Guess the Number

[![Tests](https://github.com/flrntvl/guess-the-number/actions/workflows/tests.yml/badge.svg)](https://github.com/flrntvl/guess-the-number/actions/workflows/tests.yml)

A simple number guessing CLI game built with Ruby — made as a learning project to progressively explore core Ruby concepts.

## About this project

This project was developed with the help of AI. Beyond learning Ruby, it also serves as a playground for advanced agentic coding: development tasks are orchestrated with an AI agent ([Hermes Agent](https://hermes-agent.nousresearch.com)) which implements features end-to-end — writing code and tests, committing changes following the [contribution conventions](CONTRIBUTING.md), and opening pull requests on GitHub.

## Prerequisites

Choose one of the two installation methods below.

- **Manual**: Ruby 4.0+
- **Docker**: Docker and Docker Compose

## Project structure

```
guess-the-number/
├── .github/
│   └── workflows/
│       └── tests.yml
├── bin/
│   └── guess
├── lib/
│   ├── console_input.rb
│   ├── end_of_input.rb
│   ├── game.rb
│   ├── i18n.rb
│   ├── language_selector.rb
│   ├── leaderboard_presenter.rb
│   ├── player.rb
│   ├── round.rb
│   └── scoreboard.rb
├── spec/
│   ├── game_spec.rb
│   ├── i18n_spec.rb
│   ├── language_selector_spec.rb
│   ├── leaderboard_presenter_spec.rb
│   ├── player_spec.rb
│   ├── round_spec.rb
│   ├── scoreboard_spec.rb
│   └── spec_helper.rb
├── data/
│   └── .gitkeep
├── Dockerfile
├── compose.yaml
├── Makefile
├── Gemfile
├── Gemfile.lock
├── .gitignore
├── .rubocop.yml
└── README.md
```

## How to run

### Manually

```bash
ruby bin/guess
```

### With Docker

```bash
make build
make up
```

Without `make`, the equivalent commands are:

```bash
docker compose build
docker compose run --rm guess
```

## Tests

```bash
make test
```

Without `make`: `docker compose run --rm guess bundle exec rspec`, or `bundle exec rspec` if installed manually.

The test suite (in `spec/`) was generated with the help of AI.

Tests run automatically on every push and pull request via [GitHub Actions](.github/workflows/tests.yml).

Running the suite also generates a test coverage report with [SimpleCov](https://github.com/simplecov-ruby/simplecov) in `coverage/index.html`.

## Lint

Code style is checked with [RuboCop](https://rubocop.org) (plus [rubocop-rspec](https://github.com/rubocop/rubocop-rspec) for the specs), configured in `.rubocop.yml`:

```bash
make lint
```

Without `make`: `docker compose run --rm guess bundle exec rubocop`, or `bundle exec rubocop` if installed manually.

Most style offenses can be fixed automatically:

```bash
docker compose run --rm guess bundle exec rubocop -a
```

The linter also runs in CI, before the tests.

## Technical design notes

Notes on a few implementation choices, for anyone reading or extending the code.

### `ConsoleInput` module

`Game`, `Round` and `LanguageSelector` all read player input from the console. Rather than duplicating that logic, they share the `ConsoleInput` module (`lib/console_input.rb`), which centralizes:

- **Input normalization** — each line is cleaned up on the way in: invalid byte sequences are scrubbed (so a badly encoded paste doesn't crash the game) and surrounding whitespace is stripped.
- **End-of-input handling** — when standard input closes (e.g. Ctrl+D), `gets` returns `nil`. The module converts that into a single `EndOfInput` exception, so each interactive class stays simple and `Game#start` handles EOF in one `rescue`.

### `Round::Result` struct

A finished guessing round produces two values: the number of attempts and whether the player won. Returning them as a bare array (`[attempts, success]`) would be error-prone — callers could mix up the order. Instead, `Round#play` returns a `Round::Result`, defined with `Struct.new(:attempts, :success, keyword_init: true)`:

```ruby
result = round.play
result.attempts  # => 2
result.success   # => true
```

A Struct gives named accessors plus built-in keyword initialization, equality and `to_h` without writing a full class for two data-only fields. `Game#save_result` relies on this to store each field under its proper name in `data/results.json`.

### Testing strategy: stubbing `$stdin`, not the objects

In Ruby, bare `gets` is really `$stdin.gets` — `$stdin` is the global variable holding the standard input stream (the keyboard). The specs use this as the seam for simulating a player:

```ruby
allow($stdin).to receive(:gets).and_return("Alice\n", "42\n")
```

Stubbing at this boundary rather than on game objects (`allow(game).to receive(:gets)`) keeps tests valid no matter which internal object reads the input — refactoring code between classes doesn't break them. End-to-end specs in `game_spec.rb` still use this approach; focused specs like `round_spec.rb` call `Round#play` directly with fixed settings and assert on the returned `Result`.

## How to play

- Choose your language: English or Français
- From the main menu, play, view the leaderboard or quit
- Enter your name and choose a difficulty level
- The game picks a secret number based on the chosen difficulty
- You have a limited number of attempts to guess it
- After each guess, the game tells you if you went too high or too low
- Find the number before running out of attempts to win
- The top 10 scores per difficulty (wins only, fewest attempts first) is shown after each game

## Data

Game results are saved in `data/results.json`. This folder is ignored by git — only `data/.gitkeep` is tracked to preserve the directory structure.

Each entry corresponds to one completed game (win or loss):

```json
[
  {
    "player_name": "Alice",
    "difficulty": "medium",
    "attempts": 7,
    "language": "en",
    "number_to_guess": 42,
    "success": true,
    "timestamp": "2026-05-22 10:30:00 +0200"
  }
]
```

| Field             | Type    | Description                           |
| ----------------- | ------- | ------------------------------------- |
| `player_name`     | String  | Name entered at the start             |
| `difficulty`      | String  | `"easy"`, `"medium"`, or `"hard"`     |
| `attempts`        | Integer | Number of guesses made                |
| `language`        | String  | `"en"` or `"fr"`                      |
| `number_to_guess` | Integer | The secret number                     |
| `success`         | Boolean | `true` if the player found the number |
| `timestamp`       | String  | Date and time of the game             |

## Roadmap

This project is built step by step to learn Ruby:

- [x] **Basic game** — `gets`, `rand`, `while`, `if/else`
- [x] **Difficulty levels** — menu, `Hash`, `Symbol`
- [x] **Multilingual support** — nested `Hash`, language selection
- [x] **Score saving** — `File`, `JSON`
- [x] **Leaderboard** — `sort_by`, `select`, formatted display
