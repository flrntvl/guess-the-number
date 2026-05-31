# Guess the number

A simple number guessing CLI game built with Ruby — made as a learning project to progressively explore core Ruby concepts.

## Prerequisites

- Ruby 4.0+

## How to run

```bash
ruby main.rb
```

## How to play

- The game picks a secret number in a range that depends on the difficulty level
- The number of attempts also varies by difficulty
- After each guess, the game tells you if you went too low or too high
- Find the number before running out of attempts to win
- After each game, you are asked if you want to play again
- The leaderboard is displayed once you choose to stop playing

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

## Architecture

The project is split into small classes and modules, each with a single responsibility:

| Class | File | Role |
|---|---|---|
| `Translation` | `lib/translations.rb` | Stores all translated strings; `select_language` is called from `main.rb` to pick the locale before the session starts |
| `GameSession` | `lib/game_session.rb` | Orchestrates the session: collects player name and difficulty, runs the game loop, handles play again |
| `Game` | `lib/game.rb` | Runs one game: picks a secret number, handles the guess loop, displays feedback |
| `Player` | `lib/player.rb` | Holds the player's name |
| `ScoreBoard` | `lib/score_board.rb` | Saves results to `data/results.json` and displays the leaderboard |

**Flow:**

```
main.rb  →  Translation.select_language   (picks locale)
         →  GameSession
              └─ create_player            (asks name)
              └─ loop:                                  ←┐
                   └─ select_difficulty                  │
                   └─ Game  →  runs the game loop        │
                        └─ ScoreBoard.save               │
                   └─ play again?  →  yes: repeat loop   ┘
                                   →  no:  ScoreBoard.display (leaderboard)
```

Difficulty settings (ranges, attempt limits) live in `lib/difficulty.rb`.

## Roadmap

This project is built step by step to learn Ruby:

- [x] **Basic game** — `gets`, `rand`, `while`, `if/else`
- [x] **Difficulty levels** — menu, `Hash`, `Symbol`
- [x] **Multilingual support** — nested `Hash`, language selection
- [x] **Score saving** — `File`, `JSON`
- [x] **Leaderboard** — `sort_by`, `select`, formatted display
- [x] **Refactor with classes** — `Game`, `Player`, `ScoreBoard`
