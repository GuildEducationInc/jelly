# Donut

Submit and vote for tech talks

## App
### Client
The client is a React app
### Server
The server is a Sinatra app that uses Redis as its data store

## Local development
### Prerequisites
- Redis
- Ruby 2.6.3
- Node.js
- Yarn

```sh
# spin up whole stack
git clone https://github.com/thejchap/donut.git
cd donut
make
make serve

# OR spin up just backend
make serve.server

# OR spin up just frontend
make serve.client
```

## Deployment
1. Create 2 Heroku apps and set them as `heroku-server` and `heroku-client` Git remotes locally
```sh
# deploy the entire app
make deploy

# OR deploy just frontend
make deploy.client

# OR deploy just backend
make deploy.server
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.
