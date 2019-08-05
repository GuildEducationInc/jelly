serve:
	foreman start -f Procfile.dev

deps: deps.client deps.server
	bundle

deps.client:
	cd client && yarn

deps.server:
	cd server && bundle
