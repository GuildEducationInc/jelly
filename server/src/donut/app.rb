# frozen_string_literal: true

require_relative './graphql/schema'

module Donut
  class App < ::Sinatra::Base
    configure do
      set :server, :puma
      set :bind, '0.0.0.0'
      enable :logging
      enable :cross_origin
    end

    before do
      response.headers['Access-Control-Allow-Origin'] = '*'
    end

    options '/graphql' do
      response.headers['Allow'] = 'POST'
      response.headers['Access-Control-Allow-Headers'] = '*'
      200
    end

    post '/graphql' do
      body = JSON.parse request.body.read
      result = ::Donut::GraphQL::Schema.execute(
        body['query'],
        variables: body['variables']
      )

      [200, json(result)]
    end
  end
end
