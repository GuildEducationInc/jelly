serve:
	foreman start -f Procfile.dev

deps: deps.client deps.server
	bundle

deploy: deploy.server deploy.client

deps.client:
	cd client && yarn

deps.server:
	cd server && bundle

deploy.client:
	git subtree push --prefix client heroku-client master

deploy.server:
	git subtree push --prefix server heroku-server master
