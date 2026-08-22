# Contributing to guess-the-number

This document describes the development workflow and contribution conventions used in this project.

These conventions may evolve as the project grows.

## Branching workflow

Development happens directly on `main`. Feature and maintenance branches are created from `main` and merged back into `main` — there are no milestone or development branches.

### Branch naming

Use lowercase names with hyphens, prefixed with the branch type.

Examples:

```text
feature/language-selection
fix/eof-handling
refactor/extract-guessing-loop
test/scoreboard-specs
docs/add-contributing
chore/update-dependencies
```

Common prefixes:

- `feature/` — new functionality
- `fix/` — bug fixes
- `refactor/` — code restructuring without changing behavior
- `test/` — adding or updating tests
- `docs/` — documentation changes
- `chore/` — maintenance and tooling work

## Commit messages

This project follows the [Conventional Commits 1.0.0](https://www.conventionalcommits.org/en/v1.0.0/) specification.

Commit messages should follow this format:

```text
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Commit types

Common types:

- `feat` — new feature
- `fix` — bug fix
- `docs` — documentation changes
- `refactor` — code restructuring without changing behavior
- `test` — adding or updating tests
- `chore` — maintenance work
- `style` — formatting or code style changes without behavior changes
- `perf` — performance improvements
- `build` — build system or dependency changes
- `ci` — continuous integration changes

Examples:

```text
feat: add difficulty levels
fix: handle EOF on console input gracefully
refactor: extract shared console input module
chore: add RuboCop and SimpleCov
```

A scope may optionally be used when it helps identify the area affected by the change:

```text
feat(i18n): add Spanish translations
fix(scoreboard): prevent corrupt save files
```

Scopes should remain short, lowercase, and meaningful.

### Commit descriptions

Commit descriptions should:

- use the imperative mood
- remain concise
- describe one logical change
- start with a lowercase letter
- avoid a trailing period

A commit body may be added when additional context is useful. It should explain relevant context or reasoning that is not obvious from the commit title.

## Merge strategy

Feature and maintenance branches should generally be **squash merged** into `main` when it improves the readability of the project history.

Squashing is recommended for branches containing several intermediate or implementation-level commits, but it is **not mandatory**. A branch whose commits are already clean, meaningful, and worth preserving individually may be merged without squashing.

For example, while working on a feature the branch history may temporarily look like this:

```text
feature/language-selection

feat: add language selection menu
fix: correct invalid-choice handling
chore: remove debug logs
```

After a squash merge, it becomes a single meaningful commit on `main`:

```text
feat(language-selection): add language selection menu
```

The decision should be based on the quality and usefulness of the branch history rather than on a strict rule.

## Pull requests

Even when working alone, feature branches should be merged through pull requests so that changes can be reviewed before integration.

A pull request should:

- target `main`
- remain focused on one feature or concern
- have a clear title (a Conventional Commit-style title works well)
- describe significant implementation decisions when necessary

Feature branches should not normally be merged directly into `main`.

## Documentation and AI-assisted development

Documentation is considered part of the implementation of a feature: when introducing a new feature or significant technical behavior, update the README or related docs alongside the code.

This project is also used as a playground for AI-assisted and agentic development. Good documentation and clear conventions benefit both human contributors and AI agents, which should be able to rely on repository documentation to understand the project's structure and conventions instead of inferring them only from the source code.
