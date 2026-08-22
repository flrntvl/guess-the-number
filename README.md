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
│   └── scoreboard.rb
├── spec/
│   ├── game_spec.rb
│   ├── i18n_spec.rb
│   ├── language_selector_spec.rb
│   ├── leaderboard_presenter_spec.rb
│   ├── player_spec.rb
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

| Field | Type | Description |
|---|---|---|
| `player_name` | String | Name entered at the start |
| `difficulty` | String | `"easy"`, `"medium"`, or `"hard"` |
| `attempts` | Integer | Number of guesses made |
| `language` | String | `"en"` or `"fr"` |
| `number_to_guess` | Integer | The secret number |
| `success` | Boolean | `true` if the player found the number |
| `timestamp` | String | Date and time of the game |

## Roadmap

This project is built step by step to learn Ruby:

- [x] **Basic game** — `gets`, `rand`, `while`, `if/else`
- [x] **Difficulty levels** — menu, `Hash`, `Symbol`
- [x] **Multilingual support** — nested `Hash`, language selection
- [x] **Score saving** — `File`, `JSON`
- [x] **Leaderboard** — `sort_by`, `select`, formatted display