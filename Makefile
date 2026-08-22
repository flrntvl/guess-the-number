.PHONY: build up down test lint

build:
	@docker compose build

up:
	@docker compose run --rm guess

test:
	@docker compose run --rm guess bundle exec rspec

lint:
	@docker compose run --rm guess bundle exec rubocop

down:
	@docker compose down