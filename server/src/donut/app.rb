# frozen_string_literal: true

require_relative './graphql/schema'
require_relative './services/users/find'

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
        @current_user ||= load_current_user
      end

      def load_current_user
        header = request.env['HTTP_AUTHORIZATION']
        return unless header.present?
        type, token = header.split ' '
        return unless type == 'Bearer' && token.present?
        services[:find_user].call(auth_token: token).value
      end

      def services
        {
          find_user: ::Donut::Services::Users::Find
        }
      end
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
        variables: body['variables'],
        context: { current_user: current_user }
      )

      [200, json(result)]
    end
  end
end
