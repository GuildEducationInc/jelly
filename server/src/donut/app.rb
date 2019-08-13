# frozen_string_literal: true

require_relative './graphql/schema'
require_relative './services/users/current'

module Donut
  class App < ::Sinatra::Base
    configure do
      set :server, :puma
      set :bind, '0.0.0.0'
      enable :logging
      enable :cross_origin
    end

    helpers do
      def current_user
        @current_user ||= ::Donut::Services::Users::Current.call request
      end
    end

    before do
      response.headers['Access-Control-Allow-Origin'] = '*'
    end

    options '/graphql' do
      response.headers['Allow'] = 'POST, OPTIONS'
      response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type'
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
