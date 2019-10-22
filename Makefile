.DEFAULT_GOAL := default

default: deps lint

serve:
	@foreman start -f Procfile.dev

serve.server:
	@cd server && bundle exec puma --port 4567

serve.client:
	@cd client && yarn start --port 4568

deps: deps.server deps.client

deps.client:
	@cd client && yarn

deps.server:
	@cd server && bundle

deploy: deploy.server deploy.client

deploy.client:
	@git subtree push --prefix client heroku-client master

deploy.server:
	@git subtree push --prefix server heroku-server master

lint: lint.server

lint.server:
	@cd server && bundle exec rubocop
