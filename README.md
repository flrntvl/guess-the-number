# Guess the Number

A simple number guessing CLI game built with Ruby — made as a learning project to progressively explore core Ruby concepts.

## Prerequisites

Choose one of the two installation methods below.

- **Manual**: Ruby 4.0+
- **Docker**: Docker and Docker Compose

## Project structure

```
guess-the-number/
├── bin/
│   └── guess
├── lib/
│   ├── game.rb
│   ├── player.rb
│   └── scoreboard.rb
├── data/
│   └── .gitkeep
├── Dockerfile
├── compose.yaml
├── Makefile
├── Gemfile
├── Gemfile.lock
├── .gitignore
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

## How to play

- Enter your name and choose a difficulty level
- The game picks a secret number based on the chosen difficulty
- You have a limited number of attempts to guess it
- After each guess, the game tells you if you went too high or too low
- Find the number before running out of attempts to win

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
- [ ] **Multilingual support** — nested `Hash`, language selection
- [ ] **Score saving** — `File`, `JSON`
- [ ] **Leaderboard** — `sort_by`, `select`, formatted display