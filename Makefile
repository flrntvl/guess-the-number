.PHONY: build up down test

build:
	@docker compose build

up:
	@docker compose run --rm guess

test:
	@docker compose run --rm guess bundle exec rspec

down:
	@docker compose down