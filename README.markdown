# Jelly

Submit and vote for tech talks

## App
### Client
The client is a React app. Nothing fancy here.
### Server
The server is a Sinatra app that uses Redis as its data store. Most of the persistence logic is defined in Lua scripts which are executed by Redis (https://redis.io/commands/eval)

## Local development
### Prerequisites
- Redis
- Ruby 2.6.5
- Node.js
- Yarn

```sh
# spin up whole stack
git clone https://github.com/GuildEducationInc/jelly.git
cd jelly
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

jelly is open-source and licensed under the [MIT License](LICENSE).

Use the project's [GitHub Issues feature](https://github.com/GuildEducationInc/jelly/issues) to report bugs and make feature requests.

Even better, if you're able to write code yourself to fix bugs or implement new features, [submit a pull request on GitHub](https://github.com/GuildEducationInc/jelly/pulls) which will help us move the software forward much faster.

