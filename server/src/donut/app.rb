# frozen_string_literal: true

require_relative './graphql/schema'
require_relative './services/users/current'
require_relative './redis'

Wolverine.config.script_path = Pathname.new File.expand_path('./lua', __dir__)

module Donut
  class App < ::Sinatra::Base
    configure do
      set :server, :puma
      set :bind, '0.0.0.0'
      enable :logging
      set :logging, Logger::DEBUG
      enable :cross_origin
    end

    helpers do
      def current_user
        @current_user ||= ::Donut::Services::Users::Current.call request
      end
    end

    before do
      response.headers['Access-Control-Allow-Origin'] = '*'

      ::Donut::Redis.logger = logger
      ::Wolverine.config.redis = ::Donut::Redis.instance.client
    end

    options '/graphql' do
      resp_headers = 'Authorization, Content-Type'
      response.headers['Allow'] = 'POST, OPTIONS'
      response.headers['Access-Control-Allow-Headers'] = resp_headers
      response.headers['Access-Control-Allow-Origin'] = '*'
      200
    end

    post '/graphql' do
      body = JSON.parse request.body.read

      result = ::Donut::GraphQL::Schema.execute(
        body['query'],
        variables: body['variables'],
        context: { current_user: current_user }
      )

      [200, json(result)]
    end
  end
end
