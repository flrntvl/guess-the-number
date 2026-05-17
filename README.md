# Guess the number

A simple number guessing CLI game built with Ruby — made as a learning project to progressively explore core Ruby concepts.

## Prerequisites

- Ruby 4.0+

## How to run

```bash
ruby guess.rb
```

## How to play

- The game picks a secret number between 1 and 100
- You have 10 attempts to guess it
- After each guess, the game tells you if you went too low or too high
- Find the number before running out of attempts to win

## Roadmap

This project is built step by step to learn Ruby:

- [x] **Basic game** — `gets`, `rand`, `while`, `if/else`
- [x] **Difficulty levels** — menu, `Hash`, `Symbol`
- [ ] **Multilingual support** — nested `Hash`, language selection
- [ ] **Score saving** — `File`, `JSON`
- [ ] **Leaderboard** — `sort_by`, `select`, formatted display
- [ ] **Refactor with classes** — `Game`, `Player`, `ScoreBoard`
